publishComposite 'checkin', (selected_tags, selected_author_ids, limit, checkin_view_mode)->
    {
        find: ->
            self = @
            match = {}
            # match.tags = $all: selected_tags
            if selected_tags.length > 0 then match.tags = $all: selected_tags
            if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
            match.type = 'checkin'
            if checkin_view_mode is 'resonates'
                match.favoriters = $in: [@userId]
            match.published = true
            
            if checkin_view_mode and checkin_view_mode is 'mine'
                match.author_id
        
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
        
        
        

Meteor.publish 'checkin_tags', (selected_tags, limit, checkin_view_mode)->
    
    self = @
    match = {}
    
    match.type = 'checkin'
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    
    if checkin_view_mode is 'resonates'
        match.favoriters = $in: [@userId]
    
    
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