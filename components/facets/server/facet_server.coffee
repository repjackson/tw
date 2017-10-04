Meteor.publish 'location_tags', (
    selected_theme_tags 
    selected_author_ids=[]
    selected_location_tags
    selected_intention_tags
    selected_timestamp_tags
    type
    )->
    
        self = @
        match = {}
        
        # match.tags = $all: selected_theme_tags
        match.type = 'journal'
        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
        if selected_location_tags.length > 0 then match.location_tags = $in: selected_location_tags
        if selected_intention_tags.length > 0 then match.intention_tags = $in: selected_intention_tags
        if selected_timestamp_tags.length > 0 then match.timestamp_tags = $in: selected_timestamp_tags

        # if author_id then match.author_id = author_id
        console.log match
        
        # if view_private is true then match.author_id = Meteor.userId()
        # else if view_private is false then match.published = true
                
        cloud = Docs.aggregate [
            { $match: match }
            { $project: location_tags: 1 }
            { $unwind: "$location_tags" }
            { $group: _id: '$location_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_location_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'location cloud, ', cloud
        cloud.forEach (location_tag, i) ->
            self.added 'location_tags', Random.id(),
                name: location_tag.name
                count: location_tag.count
                index: i
    
        self.ready()
        
Meteor.publish 'intention_tags', (
    selected_theme_tags
    selected_author_ids=[] 
    selected_location_tags
    selected_intention_tags
    selected_timestamp_tags
    type
    )->
        
        self = @
        match = {}
        
        # match.tags = $all: selected_theme_tags
        if type then match.type = type
        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
        if selected_location_tags.length > 0 then match.location_tags = $in: selected_location_tags
        if selected_intention_tags.length > 0 then match.intention_tags = $in: selected_intention_tags
        if selected_timestamp_tags.length > 0 then match.timestamp_tags = $in: selected_timestamp_tags
        # if author_id then match.author_id = author_id
        # console.log match
        
        # if view_private is true then match.author_id = Meteor.userId()
        # else if view_private is false then match.published = true
                
        cloud = Docs.aggregate [
            { $match: match }
            { $project: intention_tags: 1 }
            { $unwind: "$intention_tags" }
            { $group: _id: '$intention_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_intention_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention cloud, ', cloud
        cloud.forEach (intention_tag, i) ->
            self.added 'intention_tags', Random.id(),
                name: intention_tag.name
                count: intention_tag.count
                index: i
    
        self.ready()
        
    
Meteor.publish 'timestamp_tags', (
    selected_theme_tags
    selected_author_ids=[]
    selected_location_tags
    selected_intention_tags
    selected_timestamp_tags
    type
    )->
    
        self = @
        match = {}
        
        # match.tags = $all: selected_theme_tags
        match.type = 'journal'
        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
        if selected_location_tags.length > 0 then match.location_tags = $in: selected_location_tags
        if selected_intention_tags.length > 0 then match.intention_tags = $in: selected_intention_tags
        if selected_timestamp_tags.length > 0 then match.timestamp_tags = $in: selected_timestamp_tags

        # if author_id then match.author_id = author_id
        # console.log match
        
        # if view_private is true then match.author_id = Meteor.userId()
        # else if view_private is false then match.published = true
                
        cloud = Docs.aggregate [
            { $match: match }
            { $project: timestamp_tags: 1 }
            { $unwind: "$timestamp_tags" }
            { $group: _id: '$timestamp_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_timestamp_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention cloud, ', cloud
        cloud.forEach (timestamp_tag, i) ->
            self.added 'timestamp_tags', Random.id(),
                name: timestamp_tag.name
                count: timestamp_tag.count
                index: i
    
        self.ready()
        
Meteor.publish 'watson_keywords', (selected_theme_tags, selected_author_ids=[], type=null, author_id=null, parent_id=null, manual_limit=null, view_private)->
    
    self = @
    match = {}
    
    # match.tags = $all: selected_theme_tags
    if type then match.type = type
    if parent_id then match.parent_id = parent_id
    if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
    if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
    match.published = true
    # console.log 'limit:', manual_limit
    if manual_limit then limit=manual_limit else limit=50
    if author_id then match.author_id = author_id
    # console.log match
    
    if view_private is true then match.author_id = Meteor.userId()
    else if view_private is false then match.published = true
            

    
    
    cloud = Docs.aggregate [
        { $match: match }
        { $project: watson_keywords: 1 }
        { $unwind: "$watson_keywords" }
        { $group: _id: '$watson_keywords', count: $sum: 1 }
        { $match: _id: $nin: selected_theme_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: limit }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log 'cloud, ', cloud
    cloud.forEach (keyword, i) ->
        self.added 'watson_keywords', Random.id(),
            name: keyword.name
            count: keyword.count
            index: i

    self.ready()
