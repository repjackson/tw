if Meteor.isClient
    
    FlowRouter.route '/transaction/:doc_id/view',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'transaction_view'
    
    
    
    
    Template.transaction_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.transaction_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')
        balance_after_transaction: ->Meteor.user().points - @point_price

                

    Template.transaction_view.events
