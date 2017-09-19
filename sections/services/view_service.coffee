if Meteor.isClient
    Template.view_service.helpers
        balance_after_transaction: ->Meteor.user().points - @point_price

                
    Template.service_transactions.helpers
        child_transactions: ->
            Docs.find {
                type: 'transaction'
                parent_id: FlowRouter.getParam('doc_id')
            }, sort: timestamp: -1
    Template.view_service.events
