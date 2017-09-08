if Meteor.isClient
    
    FlowRouter.route '/service/:doc_id/edit',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'service_edit'
    
    
    
    
    Template.service_edit.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.service_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    Template.service_edit.events
        'click #delete_doc': ->
            if confirm 'Delete this doc?'
                Docs.remove @_id
                FlowRouter.go '/'