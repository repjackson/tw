    
Meteor.publish 'my_tickets', ->
    Docs.find
        author_id: @userId 
        type: 'support_ticket'
        
Meteor.publish 'child_docs', (parent_id)->
    Docs.find
        parent_id: parent_id
    
    
publishComposite 'group_docs', (group_id)->
    {
        find: -> Docs.find group_id: group_id
        children: [
            {
                find: (doc)-> Docs.find _id: doc.parent_id
                children: [
                    { 
                        find: (doc)-> Docs.find _id: doc.parent_id 
                        children: [
                            { find: (doc)-> Docs.find _id: doc.parent_id }
                        ]
                    }
                    {
                        find: (doc)->
                            Meteor.users.find
                                _id: doc.author_id
                    }
                ]
            }
            {
                find: (doc)->
                    Meteor.users.find
                        _id: doc.author_id
            }

        ]
    }
    
Meteor.publish 'me', ->
    Meteor.users.find @userId,
        fields: 
            courses: 1
            friends: 1
            points: 1
            status: 1
            cart: 1
            completed_ids: 1
            bookmarked_ids: 1
    
    
Meteor.publish 'tags', (selected_tags, selected_author_ids=[], type=null, author_id=null, parent_id=null, manual_limit=null, view_mode)->
    
    self = @
    match = {}
    
    # match.tags = $all: selected_tags
    if type then match.type = type
    if parent_id then match.parent_id = parent_id
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
    # match.published = true
    # console.log 'limit:', manual_limit
    if manual_limit then limit=manual_limit else limit=50
    if author_id then match.author_id = author_id
    # console.log match
    
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
        
Meteor.publish 'watson_keywords', (selected_tags, selected_author_ids=[], type=null, author_id=null, parent_id=null, manual_limit=null, view_mode)->
    
    self = @
    match = {}
    
    # match.tags = $all: selected_tags
    if type then match.type = type
    if parent_id then match.parent_id = parent_id
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
    match.published = true
    # console.log 'limit:', manual_limit
    if manual_limit then limit=manual_limit else limit=50
    if author_id then match.author_id = author_id
    # console.log match
    
    if view_mode is 'mine'
        match.author_id = Meteor.userId()
    else if view_mode is 'resonates'
        match.favoriters = $in: [@userId]
    else if view_mode is 'all'
        match.published = true
            

    
    
    cloud = Docs.aggregate [
        { $match: match }
        { $project: watson_keywords: 1 }
        { $unwind: "$watson_keywords" }
        { $group: _id: '$watson_keywords', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
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
        

publishComposite 'docs', (selected_tags, type, limit, view_mode)->
    {
        find: ->
            self = @
            match = {}
            # match.tags = $all: selected_tags
            if selected_tags.length > 0 then match.tags = $all: selected_tags
            if type then match.type = type
            # console.log view_mode
            if view_mode is 'mine'
                match.author_id = Meteor.userId()
            else if view_mode is 'resonates'
                match.favoriters = $in: [@userId]
            else if view_mode is 'all'
                match.published = true
                    
            if limit
                Docs.find match, 
                    limit: limit
            else
                Docs.find match
        children: [
            {
                find: (doc)->
                    Meteor.users.find
                        _id: doc.author_id
            }
            {
                find: (doc)->
                    Docs.find
                        _id: doc.parent_id
            }
        ]

    }

publishComposite 'doc', (id)->
    {
        find: ->
            Docs.find id
        children: [
            {
                find: (doc)->
                    Meteor.users.find
                        _id: doc.author_id
            }
            {
                find: (doc)->
                    Docs.find
                        _id: doc.parent_id
            }
        ]
    }

Meteor.publish 'doc_by_tags', (tags)->
    Docs.find
        tags: tags

    
# publishComposite 'questions', (section_id)->
#     {
#         find: ->
#             Docs.find 
#                 type: 'question'
#                 section_id: section_id
#         children: [
#             { find: (question) ->
#                 Docs.find
#                     type: 'answer'
#                     question_id: question._id
#             }
#         ]
#     }
    
        
Meteor.publish 'my_friends', ->
    me = Meteor.users.findOne @userId
    if me.friends
        Meteor.users.find {_id: $in: me.friends}
        # fields: 
        #     tags: 1
        #     courses: 1
        #     friends: 1
        #     points: 1
        #     status: 1
        #     profile: 1
    
    
    
Meteor.publish 'me_card', ->
    # console.log id
    Meteor.users.find @userId,
        fields:
            tags: 1
            profile: 1
            points: 1    
            
            
Meteor.publish 'person', (id)->
    # console.log id
    Meteor.users.find id,
        fields:
            tags: 1
            profile: 1
            points: 1            
            
            
        
Meteor.publish 'person_card', (id)->
    # console.log id
    Meteor.users.find id,
        fields:
            tags: 1
            profile: 1
            points: 1        
            
            
Meteor.publish 'people', (selected_people_tags)->
    match = {}
    if selected_people_tags.length > 0 then match.tags = $all: selected_people_tags
    match._id = $ne: @userId
    # match["profile.published"] = true
    Meteor.users.find match,
        limit: 20


Meteor.publish 'people_tags', (selected_people_tags)->
    self = @
    match = {}
    if selected_people_tags.length > 0 then match.tags = $all: selected_people_tags
    match._id = $ne: @userId
    # match["profile.published"] = true

    # console.log match

    people_cloud = Meteor.users.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_people_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log 'cloud, ', people_cloud
    people_cloud.forEach (tag, i) ->
        self.added 'people_tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()
        


# publishComposite 'transactions', ->
#     {
#         find: ->
#             Docs.find
#                 type: 'transaction'
#                 author_id: @userId            
#         children: [
#             { find: (transaction) ->
#                 Docs.find transaction.parent_id
#                 }
#             ]    
#     }



Meteor.publish 'bookmarked_tags', (selected_tags)->
    
    self = @
    match = {}
    
    match.bookmarked_ids = $in: [Meteor.userId()]
    
    # match.tags = $all: selected_tags
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    
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
        
publishComposite 'author_ids', (selected_tags, selected_author_ids, type)->
    
    {
        find: ->
            self = @
            match = {}
            if type then match.type = type
            if selected_tags.length > 0 then match.tags = $all: selected_tags
            if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
            match.published = true
            
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