    
Meteor.publish 'my_tickets', ->
    Docs.find
        author_id: @userId 
        type: 'support_ticket'
        
Meteor.publish 'child_docs', (parent_id)->
    Docs.find
        parent_id: parent_id
    
    
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
    
    
Meteor.publish 'tags', (selected_tags, type, parent_id, manual_limit, view_mode)->
    
    self = @
    match = {}
    
    # match.tags = $all: selected_tags
    if type then match.type = type
    if parent_id then match.parent_id = parent_id
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    
    console.log 'limit:', manual_limit
    if manual_limit then limit=manual_limit else limit=50
    
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
        

Meteor.publish 'docs', (selected_tags, type, limit, view_mode)->

    self = @
    match = {}
    # match.tags = $all: selected_tags
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if type then match.type = type
    # console.log view_mode
    if view_mode and view_mode is 'mine'
        match.author_id

    if limit
        Docs.find match, 
            limit: limit
    else
        Docs.find match


publishComposite 'doc', (id)->
    {
        find: ->
            Docs.find id
        children: [
            find: (doc)->
                Meteor.users.find
                    _id: doc.author_id
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
        
