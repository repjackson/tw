Meteor.publish 'child_docs', (parent_id)->
    Docs.find {parent_id: parent_id},
        limit: 20
    
Meteor.publish 'my_children', (parent_id)->
    Docs.find {
        author_id: Meteor.userId()
        parent_id: parent_id
    }, limit: 10
        
Meteor.publish 'parent_doc', (child_id)->
    child_doc = Docs.findOne child_id
    if child_doc
        Docs.find
            _id: child_doc.parent_id
    
    
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
            stats: 1
    

publishComposite 'doc', (id, ancestor_levels, descendent_levels)->
    {
        find: ->
            Docs.find id
        children: [
            { 
                # participants
                find: (conversation)->
                    if conversation.participant_ids
                        Meteor.users.find
                            _id: $in: conversation.participant_ids
            }
            {
                # author
                find: (doc)->
                    Meteor.users.find
                        _id: doc.author_id
            }
            {
                # older numeric sibling
                find: (doc)->
                    if doc.number
                        next_number = doc.number + 1
                        Docs.find
                            # group: doc.group
                            parent_id: doc.parent_id
                            number: next_number
                # children: [
                #     {
                #         #older sibling response
                #         find: (older_sibling)->
                #             Docs.find
                #                 parent_id: older_sibling._id
                #                 author_id: Meteor.userId()
                #         }
                    
                #     ]
                        
            }
            {
                # younger numeric sibling
                find: (doc)->
                    if doc.number
                        previous_number = doc.number - 1
                        Docs.find
                            # group: doc.group
                            parent_id: doc.parent_id
                            number: previous_number
                # children: [
                #     {
                #         #younger sibling response
                #         find: (younger_sibling)->
                #             Docs.find
                #                 parent_id: younger_sibling._id
                #                 author_id: Meteor.userId()
                #         }
                    
                #     ]
            }
            {
                # parent doc
                find: (doc)->
                    Docs.find
                        _id: doc.parent_id
                children: [
                    {
                        # grandparent doc
                        find: (parent_doc)->
                            Docs.find
                                _id: parent_doc.parent_id
                        children: [
                            # great grandparent doc
                            find: (grandparent_doc)->
                                Docs.find
                                    _id: grandparent_doc.parent_id
                            children: [
                                # great great grandparent doc
                                find: (great_grandparent_doc)->
                                    Docs.find
                                        _id: great_grandparent_doc.parent_id
                                children: [
                                    # great great great grandparent doc
                                    find: (great_great_grandparent_doc)->
                                        Docs.find
                                            _id: great_great_grandparent_doc.parent_id
                                    ]
                
                                ]
            
                            ]
                    }
                    {
                        # parent author
                        find: (parent_doc)->
                            Meteor.users.find
                                _id: parent_doc.author_id
                    }
                ]
            }
            # {
            #     # child doc
            #     find: (doc)->
            #         Docs.find
            #             parent_id: doc._id
            #     children: [ 
            #         {
            #             find: (child_doc)->
            #                 Meteor.users.find
            #                     _id: child_doc.author_id
            #         }
            #         # {
            #         #     #  granchild doc
            #         #     find: (child_doc)->
            #         #         # console.log child_doc
            #         #         Docs.find
            #         #             parent_id: child_doc._id
            #         # }
            #     ]
            # }
        ]
    }

Meteor.publish 'doc_by_tags', (tags)->
    Docs.find
        tags: tags

Meteor.publish 'person_by_id', (id)->
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
        { $limit: 42 }
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



Meteor.publish 'usernames', ->
    Meteor.users.find {},
        fields: 
            username: 1
            profile: 1
            points: 1
            
            
Meteor.publish 'docs', (type)->
    Docs.find
        # site: Meteor.settings.public.site.slug
        type: type            
        
Meteor.publish 'user_clouds', (username)->
    other_person = Meteor.users.findOne username:username
    Meteor.users.find {_id: $in: [other_person._id, Meteor.userId()] },
        fields: 
            journal_list: 1
            journal_cloud: 1
            checkin_list: 1
            checkin_cloud: 1
            
            


Meteor.publish 'author', (doc_id)->
    doc = Docs.findOne doc_id
    if doc 
        Meteor.users.find _id: doc.author_id
        
        
Meteor.publish 'fields', ->
    Docs.find type: 'component'
    
    
Meteor.publish 'actions', ->
    Docs.find type: 'action'
    
Meteor.publish 'field_templates', ->
    Docs.find type: 'field_template'
    
    
Meteor.publish 'templates', ->
    Docs.find type: 'template'
    
    
Meteor.publish 'tori_site_doc', ->
    Docs.find _id:'9639QAQ4yPbMLs7CA'
    
    
    
Meteor.publish 'facet', (
    selected_theme_tags
    selected_author_ids=[]
    selected_location_tags
    selected_intention_tags
    selected_timestamp_tags
    type
    parent_id
    view_private

    )->
    
        self = @
        match = {}
        limit = 20
        # match.tags = $all: selected_theme_tags
        if type then match.type = type
        if parent_id then match.parent_id = parent_id

        if view_private is true
            # console.log 'viewing private'
            match.author_id = Meteor.userId()
            match.published = $in:[-1]
            # match.points = 0
        
        if view_private is false
            match.published = $in: [0,1]


        # if selected_author_ids.length > 0 
        #     match.author_id = $in: selected_author_ids
        #     match.published = 1

        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if selected_location_tags.length > 0 then match.location_tags = $all: selected_location_tags
        if selected_intention_tags.length > 0 then match.intention_tags = $all: selected_intention_tags
        if selected_timestamp_tags.length > 0 then match.timestamp_tags = $all: selected_timestamp_tags

        # console.log 'match:', match

        theme_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_theme_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'theme theme_tag_cloud, ', theme_tag_cloud
        theme_tag_cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i

        intention_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: intention_tags: 1 }
            { $unwind: "$intention_tags" }
            { $group: _id: '$intention_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_intention_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention intention_tag_cloud, ', intention_tag_cloud
        intention_tag_cloud.forEach (intention_tag, i) ->
            self.added 'intention_tags', Random.id(),
                name: intention_tag.name
                count: intention_tag.count
                index: i

        timestamp_tags_cloud = Docs.aggregate [
            { $match: match }
            { $project: timestamp_tags: 1 }
            { $unwind: "$timestamp_tags" }
            { $group: _id: '$timestamp_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_timestamp_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 10 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention timestamp_tags_cloud, ', timestamp_tags_cloud
        timestamp_tags_cloud.forEach (timestamp_tag, i) ->
            self.added 'timestamp_tags', Random.id(),
                name: timestamp_tag.name
                count: timestamp_tag.count
                index: i
    

        location_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: location_tags: 1 }
            { $unwind: "$location_tags" }
            { $group: _id: '$location_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_location_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'location location_tag_cloud, ', location_tag_cloud
        location_tag_cloud.forEach (location_tag, i) ->
            self.added 'location_tags', Random.id(),
                name: location_tag.name
                count: location_tag.count
                index: i

        # author_match = match
        # author_match.published = 1
    
        # author_tag_cloud = Docs.aggregate [
        #     { $match: author_match }
        #     { $project: author_id: 1 }
        #     { $group: _id: '$author_id', count: $sum: 1 }
        #     { $match: _id: $nin: selected_author_ids }
        #     { $sort: count: -1, _id: 1 }
        #     { $limit: limit }
        #     { $project: _id: 0, text: '$_id', count: 1 }
        #     ]
    
    
        # console.log author_tag_cloud
        
        # author_objects = []
        # Meteor.users.find _id: $in: author_tag_cloud.
    
        # author_tag_cloud.forEach (author_id) ->
        #     self.added 'author_ids', Random.id(),
        #         text: author_id.text
        #         count: author_id.count

        # console.log Docs.findOne(match)

        doc_match = match
        # doc_match.published = -1
        # console.log doc_match
        subHandle = Docs.find(doc_match, {limit:10, sort: timestamp:-1}).observeChanges(
            added: (id, fields) ->
                # console.log 'added doc', id, fields
                # doc_results.push id
                self.added 'docs', id, fields
            changed: (id, fields) ->
                # console.log 'changed doc', id, fields
                self.changed 'docs', id, fields
            removed: (id) ->
                # console.log 'removed doc', id, fields
                # doc_results.pull id
                self.removed 'docs', id
        )
        
            

        self.ready()
        
        self.onStop ()-> subHandle.stop()
    