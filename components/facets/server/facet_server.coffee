Meteor.publish 'facet', (
    selected_theme_tags
    selected_author_ids=[]
    selected_location_tags
    selected_intention_tags
    selected_timestamp_tags
    type
    author_id=null
    parent_id=null
    manual_limit=null
    view_private
    view_published
    view_unread
    view_bookmarked
    view_resonates
    )->
    
        self = @
        match = {}
        
        # match.tags = $all: selected_theme_tags
        if type then match.type = type
        if parent_id then match.parent_id = parent_id

        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
        if selected_location_tags.length > 0 then match.location_tags = $in: selected_location_tags
        if selected_intention_tags.length > 0 then match.intention_tags = $in: selected_intention_tags
        if selected_timestamp_tags.length > 0 then match.timestamp_tags = $in: selected_timestamp_tags
        
        if manual_limit then limit=manual_limit else limit=50
        if author_id then match.author_id = author_id
        
        if view_private is true then match.author_id = @userId
        if view_resonates is 'resonates'then match.favoriters = $in: [@userId]
        if view_published is true then match.published = true
        if view_bookmarked is true then match.bookmarked_ids = $in: [@userId]

        
        # console.log 'match:', match
        
        
        theme_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_theme_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'theme theme_tag_cloud, ', theme_tag_cloud
        theme_tag_cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i


        watson_keyword_cloud = Docs.aggregate [
            { $match: match }
            { $project: watson_keywords: 1 }
            { $unwind: "$watson_keywords" }
            { $group: _id: '$watson_keywords', count: $sum: 1 }
            { $match: _id: $nin: selected_theme_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        watson_keyword_cloud.forEach (keyword, i) ->
            self.added 'watson_keywords', Random.id(),
                name: keyword.name
                count: keyword.count
                index: i

        timestamp_tags_cloud = Docs.aggregate [
            { $match: match }
            { $project: timestamp_tags: 1 }
            { $unwind: "$timestamp_tags" }
            { $group: _id: '$timestamp_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_timestamp_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention timestamp_tags_cloud, ', timestamp_tags_cloud
        timestamp_tags_cloud.forEach (timestamp_tag, i) ->
            self.added 'timestamp_tags', Random.id(),
                name: timestamp_tag.name
                count: timestamp_tag.count
                index: i
    
    
        intention_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: intention_tags: 1 }
            { $unwind: "$intention_tags" }
            { $group: _id: '$intention_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_intention_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention intention_tag_cloud, ', intention_tag_cloud
        intention_tag_cloud.forEach (intention_tag, i) ->
            self.added 'intention_tags', Random.id(),
                name: intention_tag.name
                count: intention_tag.count
                index: i

    
        location_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: location_tags: 1 }
            { $unwind: "$location_tags" }
            { $group: _id: '$location_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_location_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'location location_tag_cloud, ', location_tag_cloud
        location_tag_cloud.forEach (location_tag, i) ->
            self.added 'location_tags', Random.id(),
                name: location_tag.name
                count: location_tag.count
                index: i


        author_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: author_id: 1 }
            { $group: _id: '$author_id', count: $sum: 1 }
            { $match: _id: $nin: selected_author_ids }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, text: '$_id', count: 1 }
            ]
    
    
        # console.log author_tag_cloud
        
        # author_objects = []
        # Meteor.users.find _id: $in: author_tag_cloud.
    
        author_tag_cloud.forEach (author_id) ->
            self.added 'author_ids', Random.id(),
                text: author_id.text
                count: author_id.count

        # found_docs = Docs.find(match).fetch()
        # found_docs.forEach (found_doc) ->
        #     self.added 'docs', doc._id, fields
        #         text: author_id.text
        #         count: author_id.count
        

        subHandle = Docs.find(match).observeChanges(
            added: (id, fields) ->
                # console.log 'added doc', id, fields
                self.added 'docs', id, fields
            changed: (id, fields) ->
                # console.log 'changed doc', id, fields
                self.changed 'docs', id, fields
            removed: (id) ->
                # console.log 'removed doc', id, fields
                self.removed 'docs', id
        )

        self.ready()
        
        self.onStop ()-> subHandle.stop()
