if Meteor.isClient
    
    FlowRouter.route '/conversation/:doc_id/edit',
        action: (params) ->
            name: 'conversation_edit'
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'conversation_edit'
    
    
    
    
    Template.conversation_edit.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
        @autorun -> Meteor.subscribe 'usernames'


    Template.conversation_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    Template.conversation_edit.events
        'click #delete_doc': ->
            if confirm 'Delete this Conversation?'
                Docs.remove @_id
                FlowRouter.go '/conversation'
