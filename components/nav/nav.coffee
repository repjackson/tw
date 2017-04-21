if Meteor.isClient
    Template.nav.events
        'click #logout': -> AccountsTemplates.logout()
    
    Template.body.events
        'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')
        
    Template.nav.onCreated ->
        @autorun -> Meteor.subscribe 'me'
        @autorun -> Meteor.subscribe 'cart'
        
    Template.nav.onRendered ->
        Meteor.setTimeout =>
            $('.ui.dropdown').dropdown()
        , 500


    Template.nav.helpers
        cart_items: -> Docs.find({type: 'cart_item'},{author_id: Meteor.userId()}).count()


if Meteor.isServer
    Meteor.publish 'me', ->
        Meteor.users.find @userId,
            fields: 
                courses: 1
                friends: 1
                points: 1
                status: 1
                cart: 1
