if Meteor.isClient
    Template.nav.events
        'click #logout': -> 
            AccountsTemplates.logout()
            
        
    Template.nav.onCreated ->
        @autorun -> Meteor.subscribe 'my_notifications'
        
    Template.nav.helpers
        notifications: -> 
            Notifications.find()



if Meteor.isServer
    Meteor.publish 'my_notifications', ->
        Notifications.find()