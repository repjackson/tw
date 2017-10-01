publishComposite 'checkin', (selected_theme_tags, selected_author_ids, limit, view_private, view_unread)->
    {
        find: ->
            self = @
            match = {}
            # match.tags = $all: selected_theme_tags
            if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
            if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
            match.type = 'checkin'
            
            # if view_mode is 'mine'
            #     match.author_id = Meteor.userId()
            # else if view_mode is 'resonates'
            #     match.favoriters = $in: [@userId]
            # else if view_mode is 'all'
            #     match.published = true
            
            
            if view_private is true then match.author_id = Meteor.userId()
            # else if view_private is 'resonates'
            #     match.favoriters = $in: [@userId]
            else if view_private is false then match.published = true
            
            if view_unread is true then match.read_by = $nin: [Meteor.userId()]
            
        
            if limit
                Docs.find match, 
                    limit: limit
                    sort: timestamp: -1
            else
                Docs.find match,
                    sort: timestamp: -1
        children: [
            { find: (doc) ->
                Meteor.users.find 
                    _id: doc.author_id
                }
            ]    
    }
        
        
        

Meteor.publish 'checkin_tags', (selected_theme_tags, limit, view_mode)->
    
    self = @
    match = {}
    
    match.type = 'checkin'
    if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
    
    if view_mode is 'mine'
        match.author_id = Meteor.userId()
    else if view_mode is 'resonates'
        match.favoriters = $in: [@userId]
    else if view_mode is 'all'
        match.published = true
            
    
    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: "$tags" }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_theme_tags }
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