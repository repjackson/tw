FlowRouter.route '/conversation/:doc_id/view',
    action: (params) ->
        BlazeLayout.render 'layout',
            # top: 'nav'
            main: 'conversation_view'


Template.conversation_view.onCreated ->
    # console.log FlowRouter.getParam 'doc_id'
    @autorun -> Meteor.subscribe 'conversation', FlowRouter.getParam('doc_id')


Template.conversation_view.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

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




Template.conversation_view.events


