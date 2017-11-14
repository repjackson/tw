if Meteor.isClient
    Template.conversation_list.onCreated ->
        @autorun => Meteor.subscribe 'my_conversations'
    Template.conversation_list_item.onCreated ->
        @autorun => Meteor.subscribe 'group_docs', @data._id
        @autorun => Meteor.subscribe 'people_list', @data._id

        
    Template.conversation_list.helpers
        conversation_list_items: ->
            Docs.find
                type: 'conversation'
                participant_ids: $in: [Meteor.userId()]        
        
        message_segment_class: -> if Meteor.userId() in @read_by then 'basic' else ''
        read: -> Meteor.userId() in @read_by

    Template.conversation_list_item.helpers
        participants: ->
            participant_array = []
            for participant in @participant_ids
                unless Meteor.userId() is participant
                    participant_object = Meteor.users.findOne participant
                    participant_array.push participant_object
            return participant_array

        last_message: ->
            Docs.findOne {
                type: 'message'
                group_id: @_id
            }, 
                sort: timestamp: -1
                limit: 1

        conversation_list_item_class: -> if Session.equals 'current_conversation_id', @_id then 'blue inverted tertiary' else ''
    Template.conversation_list.events
        'click .conversation_list_item': (e,t)->
            Session.set 'current_conversation_id', @_id
            console.log Session.get 'current_conversation_id'
        
        'click .mark_unread': (e,t)-> 
            Meteor.call 'mark_unread', @_id, ->
                $(e.currentTarget).closest('.message_segment').transition('pulse')


Meteor.methods 
    
if Meteor.isServer
    Meteor.publish 'my_conversations', ->
        Docs.find
            type: 'conversation'
            participant_ids: $in: [Meteor.userId()]