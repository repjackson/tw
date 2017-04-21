if Meteor.isClient
    Template.my_purchases.onCreated ->
        @autorun => Meteor.subscribe 'my_purchases'
        
    Template.my_purchases.helpers
        purchases: -> 
            Docs.find
                type: 'purchase'
                author_id: Meteor.userId()
                
        parent_doc: ->
            Docs.findOne @parent_id

if Meteor.isServer
    publishComposite 'my_purchases', ->
        {
            find: ->
                Docs.find
                    type: 'purchase'
                    author_id: @userId            
            children: [
                { find: (purchase) ->
                    Docs.find purchase.parent_id
                    }
                ]    
        }
