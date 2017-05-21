if Meteor.isClient
    
    Session.setDefault 'checkin_view_mode', 'all'
    # @selected_tags = new ReactiveArray []
    
    
    Template.checkin_cloud.onCreated ->
        @autorun => Meteor.subscribe('checkin_tags', selected_tags.array(), limit=20, checkin_view_mode=Session.get('checkin_view_mode'))
    
    Template.checkin_cloud.helpers
        checkin_tags: ->
            doc_count = Docs.find(type:'checkin').count()
            # if selected_tags.array().length
            if 0 < doc_count < 3
                Tags.find { 
                    count: $lt: doc_count
                    }, limit:10
            else
                # console.log 'media tags?', media_tags
                cursor = Tags.find({}, limit:10)
                
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
    
    
    
    Template.checkin_cloud.events
        'click .select_tag': -> selected_tags.push @name
        'click .unselect_tag': -> selected_tags.remove @valueOf()
        'click #clear_tags': -> selected_tags.clear()
    
        'click #add': ->
            new_id = Docs.insert type:'checkin'
            FlowRouter.go "/edit/#{new_id}"
    
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
    
        'keyup #quick_add': (e,t)->
            e.preventDefault
            tag = $('#quick_add').val().toLowerCase()
            if e.which is 13
                if tag.length > 0
                    split_tags = tag.match(/\S+/g)
                    $('#quick_add').val('')
                    Meteor.call 'add_checkin', split_tags
                    selected_tags.clear()
                    for tag in split_tags
                        selected_tags.push tag
