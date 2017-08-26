if Meteor.isClient    
    Session.setDefault 'journal_view_mode', 'all'
    # @selected_tags = new ReactiveArray []
    
    Template.journal_cloud.onCreated ->
        @autorun => 
            Meteor.subscribe('journal_tags', 
                selected_tags.array(), 
                limit=100, 
                view_bookmarked=Session.get('view_bookmarked'), 
                view_published=Session.get('view_published')
                view_unpublished=Session.get('view_unpublished')
                )
    
    Template.journal_cloud.helpers
        journal_tags: ->
            doc_count = Docs.find(type:'journal').count()
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
                when @index <= 5 then button_class.push ' '
                when @index <= 12 then button_class.push 'small '
                when @index <= 20 then button_class.push ' tiny'
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
    
    
    
    Template.journal_cloud.events
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
    
if Meteor.isServer
    Meteor.publish 'journal_tags', (selected_tags)->
        
        self = @
        match = {}
        
        match.type = 'journal'
        match.author_id = Meteor.userId()
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 10 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()