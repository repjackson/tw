@Notifications = new Meteor.Collection 'notifications'

Notifications.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.user_id = Meteor.userId()
    doc.read = false
    return

Meteor.methods
    create_notification: (text) ->
        Notifications.insert
            text: text
            
            
FlowRouter.route '/notifications', action: ->
    BlazeLayout.render 'layout', 
        main: 'notifications'

if Meteor.isServer
    Meteor.publish 'my_notifications', ->
        Notifications.find
            user_id: Meteor.userId()
        
if Meteor.isClient
    Template.notifications.onCreated ->
        @autorun -> Meteor.subscribe 'my_notifications'
    
    Template.notifications.helpers
        notifications: -> Notifications.find()