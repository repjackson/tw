
if Meteor.isClient
    
    Template.favorite_button.helpers
        favorite_count: -> Template.parentData(0).favorite_count
        
        favorite_item_class: -> 
            if Meteor.userId()
                if Template.parentData(0).favoriters and Meteor.userId() in Template.parentData(0).favoriters then 'red' else 'outline'
            else 'grey disabled'
        
    Template.favorite_button.events
        'click .favorite_item': -> 
            if Meteor.userId() then Meteor.call 'favorite', Template.parentData(0)
            else FlowRouter.go '/sign-in'
    
    
    Template.favorites_card.onCreated ->
        @autorun -> Meteor.subscribe 'favorite_docs'
        
        
    Template.favorites_card.helpers
        my_favorites: ->
            Docs.find
                favoriters: $in: [Meteor.userId()]



Meteor.methods
    favorite: (doc)->
        if doc.favoriters and Meteor.userId() in doc.favoriters
            Docs.update doc._id,
                $pull: favoriters: Meteor.userId()
                $inc: favorite_count: -1
            Meteor.users.update Meteor.userId(),
                $pull: "profile.favorites": doc._id
        else
            Docs.update doc._id,
                $addToSet: favoriters: Meteor.userId()
                $inc: favorite_count: 1
            Meteor.users.update Meteor.userId(),
                $addToSet: "profile.favorites": doc._id



    
if Meteor.isServer
    Meteor.publish 'favorite_docs', ->
        Docs.find 
            favoriters: $in: [@userId]
    