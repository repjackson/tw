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
            
            


Meteor.publish 'new_facet', (
    selected_theme_tags
    parent_id
    type
    tag_limit
    doc_limit
    view_private
    )->
        self = @
        match = {}
        
        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if type then match.type = type
        if parent_id then match.parent_id = parent_id

        # match.site = Meteor.settings.public.site
        if view_private is true
            match.author_id = Meteor.userId()
        
        if view_private is false
            match.published = $in: [0,1]

        # console.log match    
        
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


        # doc_results = []
        int_doc_limit = parseInt doc_limit
        subHandle = Docs.find(match, {limit:10, sort: timestamp:-1}).observeChanges(
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
        
        # for doc_result in doc_results
            
        # user_results = Meteor.users.find(_id:$in:doc_results).observeChanges(
        #     added: (id, fields) ->
        #         # console.log 'added doc', id, fields
        #         self.added 'docs', id, fields
        #     changed: (id, fields) ->
        #         # console.log 'changed doc', id, fields
        #         self.changed 'docs', id, fields
        #     removed: (id) ->
        #         # console.log 'removed doc', id, fields
        #         self.removed 'docs', id
        # )
        
        
        
        # console.log 'doc handle count', subHandle._observeDriver._results

        self.ready()
        
        self.onStop ()-> subHandle.stop()


Meteor.publish 'author', (doc_id)->
    doc = Docs.findOne doc_id
    if doc 
        Meteor.users.find _id: doc.author_id
        
        
Meteor.publish 'fields', ->
    Docs.find type: 'component'