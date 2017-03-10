FlowRouter.route '/account/favorites/', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'account_nav'
        main: 'favorites'


if Meteor.isClient
    Template.favorites.onCreated ->
        @autorun -> Meteor.subscribe 'favorites'
    
    
    
    Template.favorites.helpers
        favorites: -> Docs.find()
    
    Template.favorites.events
    
    
    
if Meteor.isServer
    Meteor.publish 'favorites', ->
        Docs.find
            favoriters: $in: [@userId]