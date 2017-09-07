if Meteor.isClient
    
    FlowRouter.route '/lightbank/:doc_id/view',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'lightbank_view'
    
    
    
    
    Template.lightbank_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.lightbank_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')


    Template.lightbank_view.events
