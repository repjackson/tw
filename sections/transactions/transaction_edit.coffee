if Meteor.isClient
    
    FlowRouter.route '/transaction/:doc_id/edit',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'transaction_edit'
    
    
    
    
    Template.transaction_edit.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.transaction_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    Template.transaction_edit.events
        'click #delete_doc': ->
            if confirm 'Delete this doc?'
                Docs.remove @_id
                FlowRouter.go '/'