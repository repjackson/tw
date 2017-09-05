if Meteor.isClient
    FlowRouter.route '/transactions', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            main: 'transactions'
    
    Template.transactions.onCreated ->
        @autorun => Meteor.subscribe 'transactions'
        Meteor.subscribe 'usernames'
        
    Template.transactions.helpers
        transactions: -> 
            Docs.find
                type: 'transaction'
                # author_id: Meteor.userId()
                

if Meteor.isServer
    publishComposite 'transactions', ->
        {
            find: ->
                Docs.find
                    type: 'transaction'
                    # author_id: @userId            
            children: [
                { find: (transaction) ->
                    Docs.find transaction.parent_id
                    }
                ]    
        }
