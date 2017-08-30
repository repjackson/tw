if Meteor.isClient    
    Session.setDefault 'journal_view_mode', 'all'
    # @selected_tags = new ReactiveArray []
    
    Template.journal_cloud.onCreated ->
        @autorun => 
            Meteor.subscribe('journal_tags', 
                selected_tags.array(), 
                selected_author_ids.array()
                limit=20, 
                view_bookmarked=Session.get('view_bookmarked'), 
                view_published=Session.get('view_published')
                view_unpublished=Session.get('view_unpublished')
                )
            Meteor.subscribe('author_ids', 
                selected_tags.array(), 
                selected_author_ids.array()
                limit=20, 
                view_bookmarked=Session.get('view_bookmarked'), 
                view_published=Session.get('view_published')
                view_unpublished=Session.get('view_unpublished')
                )
            Meteor.subscribe 'usernames'
    
    Template.journal_cloud.helpers
        journal_tags: ->
            doc_count = Docs.find(type:'journal').count()
            # if selected_tags.array().length
            if 0 < doc_count < 3
                Tags.find { 
                    count: $lt: doc_count
                    }, limit:20
            else
                Tags.find({}, limit:20)
                
        author_tags: ->
            author_usernames = []
            
            for author_id in Author_ids.find().fetch()
                found_user = Meteor.users.findOne(author_id.text).username
                # if found_user
                    # console.log Meteor.users.findOne(author_id.text).username
                author_usernames.push Meteor.users.findOne(author_id.text).username
            author_usernames
                
        cloud_tag_class: ->
            button_class = []
            switch
                when @index <= 5 then button_class.push ' '
                when @index <= 12 then button_class.push 'small '
                when @index <= 20 then button_class.push ' tiny'
            return button_class
    
        selected_tags: -> selected_tags.array()
        # selected_author_ids: -> selected_author_ids.array()
        selected_author_ids: ->
            selected_author_usernames = []
            for selected_author_id in selected_author_ids.array()
                selected_author_usernames.push Meteor.users.findOne(selected_author_id).username
            selected_author_usernames
        
        
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
    
        'click .select_author': ->
            selected_author = Meteor.users.findOne username: @valueOf()
            selected_author_ids.push selected_author._id
        'click .unselect_author': -> 
            selected_author = Meteor.users.findOne username: @valueOf()
            selected_author_ids.remove selected_author._id
        'click #clear_authors': -> selected_author_ids.clear()
    

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
    Meteor.publish 'journal_tags', (selected_tags, selected_author_ids)->
        
        self = @
        match = {}
        
        match.type = 'journal'
        match.author_id = Meteor.userId()
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids

        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
    publishComposite 'author_ids', (selected_tags, selected_author_ids)->
        
        {
            find: ->
                self = @
                match = {}
                match.type = 'journal'
                if selected_tags.length > 0 then match.tags = $all: selected_tags
                if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
            
                cloud = Docs.aggregate [
                    { $match: match }
                    { $project: author_id: 1 }
                    { $group: _id: '$author_id', count: $sum: 1 }
                    { $match: _id: $nin: selected_author_ids }
                    { $sort: count: -1, _id: 1 }
                    { $limit: 20 }
                    { $project: _id: 0, text: '$_id', count: 1 }
                    ]
            
            
                # console.log cloud
                
                # author_objects = []
                # Meteor.users.find _id: $in: cloud.
            
                cloud.forEach (author_id) ->
                    self.added 'author_ids', Random.id(),
                        text: author_id.text
                        count: author_id.count
                self.ready()
            
            children: [
                { find: (doc) ->
                    Meteor.users.find 
                        _id: doc.author_id
                    }
                ]    
        }