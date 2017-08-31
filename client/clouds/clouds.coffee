Template.username_filter.onCreated ->
    @autorun => 
        Meteor.subscribe('author_ids', 
            selected_tags.array()
            selected_author_ids.array()
            type=@data.type
            )
        Meteor.subscribe 'usernames'



Template.username_filter.helpers
    author_tags: ->
        author_usernames = []
        
        for author_id in Author_ids.find().fetch()
            found_user = Meteor.users.findOne(author_id.text).username
            # if found_user
                # console.log Meteor.users.findOne(author_id.text).username
            author_usernames.push Meteor.users.findOne(author_id.text).username
        author_usernames


    selected_author_ids: ->
        selected_author_usernames = []
        for selected_author_id in selected_author_ids.array()
            selected_author_usernames.push Meteor.users.findOne(selected_author_id).username
        selected_author_usernames
    
    
Template.username_filter.events
    'click .select_author': ->
        selected_author = Meteor.users.findOne username: @valueOf()
        selected_author_ids.push selected_author._id
    'click .unselect_author': -> 
        selected_author = Meteor.users.findOne username: @valueOf()
        selected_author_ids.remove selected_author._id
    'click #clear_authors': -> selected_author_ids.clear()


@selected_tags = new ReactiveArray []


Template.tag_filter.onCreated ->
    @autorun => 
        Meteor.subscribe('tags', 
            selected_tags.array()
            selected_author_ids.array()
            type=@data.type
            )

Template.tag_filter.helpers
    journal_tags: ->
        doc_count = Docs.find(type:'journal').count()
        # if selected_tags.array().length
        if 0 < doc_count < 3
            Tags.find { 
                count: $lt: doc_count
                }, limit:20
        else
            Tags.find({}, limit:20)
            
            
    cloud_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push ' '
            when @index <= 12 then button_class.push 'small '
            when @index <= 20 then button_class.push ' tiny'
        return button_class

    selected_tags: -> selected_tags.array()
    # selected_author_ids: -> selected_author_ids.array()
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



Template.tag_filter.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()



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
