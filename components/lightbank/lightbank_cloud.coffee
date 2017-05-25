if Meteor.isClient    
    Session.setDefault 'lightbank_view_mode', 'all'
    # @selected_tags = new ReactiveArray []
    
    media_tags = ['tori webster','quote','poem', 'photo', 'image', 'video', 'essay']
    
    Template.lightbank_cloud.onCreated ->
        @autorun => 
            Meteor.subscribe('lightbank_tags', 
                selected_tags.array(), 
                limit=100, 
                view_resonates=Session.get('view_resonates'), 
                view_bookmarked=Session.get('view_bookmarked'), 
                view_completed=Session.get('view_completed')
                view_published=Session.get('view_published')
                view_unpublished=Session.get('view_unpublished')
                )
    
    Template.lightbank_cloud.helpers
        media_tags: -> 
            Tags.find
                name: $in: media_tags
            
        theme_tags: ->
            doc_count = Docs.find(type:'lightbank').count()
            # if selected_tags.array().length
            if 0 < doc_count < 3
                Tags.find { 
                    count: $lt: doc_count
                    name: $nin: media_tags
                    }, limit:10
            else
                # console.log 'media tags?', media_tags
                cursor = Tags.find({name: $nin: media_tags}, limit:10)
                
        media_tag_class: -> 
            button_class = []
            if @valueOf() in selected_tags.array() then button_class.push 'teal' else button_class.push 'basic'
    
            if @name is 'tori webster' then button_class.push ' blue'
            button_class
    
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
    
    
    
    Template.lightbank_cloud.events
        'click .select_tag': -> selected_tags.push @name
        'click .unselect_tag': -> selected_tags.remove @valueOf()
        'click #clear_tags': -> selected_tags.clear()
    
        'click #add': ->
            new_id = Docs.insert 
                type:'lightbank'
                tags: selected_tags.array()
            Session.set 'view_unpublished', true
            Session.set 'editing_id', new_id

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
    Meteor.publish 'lightbank_tags', (selected_tags, limit, view_resonates, view_bookmarked, view_completed, view_published, view_unpublished)->
        
        self = @
        match = {}
        
        match.type = 'lightbank'
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        
        if view_resonates then match.favoriters = $in: [@userId]
        if view_bookmarked then match.bookmarked_ids = $in: [@userId]
        if view_completed then match.completed_ids = $in: [@userId]
        if view_published then match.published = true
        if view_unpublished then match.published = false
        
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()