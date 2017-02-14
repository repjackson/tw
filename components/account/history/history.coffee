if Meteor.isClient
    Template.history.onCreated ->
        @autorun -> Meteor.subscribe('purchase_history')
        
    
    Template.history.helpers
        purchases: -> 
            Docs.find()
    
    
    Template.history.events


if Meteor.isServer
    Meteor.publish 'purchase_history', ->
        Docs.find 
            # author_id: @userId
            type: 'payment'