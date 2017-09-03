FlowRouter.route '/conversation/view/:doc_id',
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

Template.conversation_view.events


