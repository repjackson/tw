if Meteor.isClient
    Template.view_need.onCreated ->
    
    Template.view_need.helpers
        balance_after_transaction: -> Meteor.user().points + @bounty

                
    Template.need_transactions.helpers
        child_transactions: ->
            Docs.find {
                type: 'transaction'
                parent_id: FlowRouter.getParam('doc_id')
            }, sort: timestamp: -1
    Template.view_need.events
