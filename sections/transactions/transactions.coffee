@Transactions = new Meteor.Collection 'transactions'

Transactions.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.status = 'draft'
    doc.read = false
    doc.archived = false
    return

Transactions.helpers
    sender: -> Meteor.users.findOne @sender_id
    when: -> moment(@timestamp).fromNow()
    receiver: -> Meteor.users.findOne @receiver_id
    parent: -> Transactions.findOne @parent_id

if Meteor.isClient
    FlowRouter.route '/transactions', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            main: 'transactions'
    
    Template.transactions.onCreated ->
        @autorun => Meteor.subscribe 'transactions'
        
    Template.transactions.helpers
        transactions: -> 
            Docs.find
                type: 'transaction'
                author_id: Meteor.userId()
                
        parent_doc: ->
            Docs.findOne @parent_id

if Meteor.isServer
    publishComposite 'transactions', ->
        {
            find: ->
                Docs.find
                    type: 'transaction'
                    author_id: @userId            
            children: [
                { find: (transaction) ->
                    Docs.find transaction.parent_id
                    }
                ]    
        }
