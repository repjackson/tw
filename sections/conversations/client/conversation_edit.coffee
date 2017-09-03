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


    Template.conversation_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    Template.conversation_edit.events
        'click #save_doc': ->
            FlowRouter.go "/conversation/view/#{@_id}"
            # selected_tags.clear()
            # selected_tags.push tag for tag in @tags
    
        'click #delete_doc': ->
            if confirm 'Delete this Conversation?'
                Docs.remove @_id
                FlowRouter.go '/conversation'
