@selected_tags = new ReactiveArray []

Template.cloud.onCreated ->
    @autorun => Meteor.subscribe('tags', selected_tags.array(), type=@data.type, parent_id=@data.parent_id, limit=20, view_mode=Session.get('view_mode'))
    console.log @data
Template.cloud.helpers
    cloud_tags: ->
        doc_count = Docs.find().count()
        if 0 < doc_count < 3
            Tags.find { 
                count: $lt: doc_count
                }, limit:10
        else
            # console.log 'media tags?', media_tags
            Tags.find({}, limit:10)
    
    cloud_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push ' large'
            when @index <= 12 then button_class.push ' '
            when @index <= 20 then button_class.push ' small'
        return button_class

    selected_tags: -> selected_tags.array()

    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }



Template.cloud.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()

    # 'click #add': ->
    #     new_id = Docs.insert type:'lightbank'
    #     FlowRouter.go "/edit/#{new_id}"

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_tags.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_tags.push doc.name
        $('#search').val ''

