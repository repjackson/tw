Template.view_conversation.helpers
    participants: ->
        participants = []
        for participant_id in @participant_ids
            participants.push Meteor.users.findOne participant_id
        participants

    conversation_messages: -> 
        Docs.find {
            type: 'message'
            group_id: @_id },
            sort: timestamp: 1

    message_count: -> 
        Docs.find({
            type: 'message'
            group_id: @_id }).count()

    unread_message_count: -> 
        Docs.find({
            type: 'message'
            group_id: @_id 
            read_by: $nin: [Meteor.userId()]}).count()


    subscribed: -> @_id in Docs.findOne(FlowRouter.getParam('doc_id')).subscribers