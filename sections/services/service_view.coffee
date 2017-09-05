if Meteor.isClient
    
    FlowRouter.route '/service/:doc_id/view',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'service_view'
    
    
    
    
    Template.service_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.service_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')


    Template.service_view.events
