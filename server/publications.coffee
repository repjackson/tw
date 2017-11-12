Meteor.publish 'child_docs', (parent_id)->
    Docs.find
        parent_id: parent_id
    
Meteor.publish 'my_children', (parent_id)->
    Docs.find {
        author_id: Meteor.userId()
        parent_id: parent_id
    }, limit: 10
        
Meteor.publish 'parent_doc', (child_id)->
    child_doc = Docs.findOne child_id
    Docs.find
        _id: child_doc.parent_id
    
    
    
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
                # recipient
                find: (doc)->
                    if doc.recipient_id
                        Meteor.users.find
                            _id: doc.recipient_id
            }
            {
                # object
                find: (doc)->
                    Docs.find
                        _id: doc.object_id
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
                            # children: [
                            #     # great great grandparent doc
                            #     find: (great_grandparent_doc)->
                            #         Docs.find
                            #             _id: great_grandparent_doc.parent_id
                            #     children: [
                            #         # great great great grandparent doc
                            #         find: (great_great_grandparent_doc)->
                            #             Docs.find
                            #                 _id: great_great_grandparent_doc.parent_id
                            #         ]
                
                            #     ]
            
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
            #         {
            #             #  granchild doc
            #             find: (child_doc)->
            #                 # console.log child_doc
            #                 Docs.find
            #                     parent_id: child_doc._id
            #         }
            #     ]
            # }
        ]
    }

Meteor.publish 'doc_by_tags', (tags)->
    Docs.find
        tags: tags

Meteor.publish 'person', (id)->
    # console.log id
    Meteor.users.find id,
        fields:
            tags: 1
            profile: 1
            points: 1            
            
            

Meteor.publish 'usernames', ->
    Meteor.users.find {},
        fields: 
            username: 1
            profile: 1
            points: 1
            