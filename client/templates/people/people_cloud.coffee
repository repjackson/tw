@selected_people_tags = new ReactiveArray []

Template.people_cloud.onCreated ->
    @autorun -> Meteor.subscribe 'people_tags', selected_people_tags.array()

Template.people_cloud.helpers
    all_people_tags: ->
        user_count = Meteor.users.find(_id: $ne:Meteor.userId()).count()
        if 0 < user_count < 3 then People_tags.find({ count: $lt: user_count }, {limit:42}) else People_tags.find({}, limit:42)
        # People_tags.find()

    selected_people_tags: -> selected_people_tags.array()

    cloud_tag_class: ->
        button_class = switch
            when @index <= 10 then 'big'
            when @index <= 20 then 'large'
            when @index <= 30 then ''
            when @index <= 40 then 'small'
            when @index <= 50 then 'tiny'
        return button_class
    
    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: People_tags
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }


Template.people_cloud.events
    'click .select_tag': -> selected_people_tags.push @name
    'click .unselect_tag': -> selected_people_tags.remove @valueOf()
    'click #clear_tags': -> selected_people_tags.clear()


    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_people_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_people_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_people_tags.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_people_tags.push doc.name
        $('#search').val ''
