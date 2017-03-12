if Meteor.isClient
    Template.nav.events
        'click #logout': -> 
            AccountsTemplates.logout()
            
        
    Template.nav.onCreated ->
        @autorun -> 
            Meteor.subscribe 'me'
        


if Meteor.isServer
    Meteor.publish 'me', ->
        Meteor.users.find @userId,
            fields: 
                courses: 1
