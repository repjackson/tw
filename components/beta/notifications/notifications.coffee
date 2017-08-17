@Notifications = new Meteor.Collection 'notifications'

Notifications.before.insert (user_id, doc)->
    doc.timestamp = Date.now()
    doc.user_id = Meteor.userId()
    doc.read = false
    return
    
    
Notifications.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    recipient: -> Meteor.users.findOne @recipient_id
    
Meteor.methods
    notify: (recipient_id, text) ->
        new_id = Notifications.insert
            recipient_id: recipient_id
            text: text
        return new_id

            
FlowRouter.route '/notifications', action: ->
    BlazeLayout.render 'layout', 
        main: 'notifications'

if Meteor.isClient
    Template.notifications.onCreated ->
        @autorun -> Meteor.subscribe 'received_notifications'
    
    Template.notifications.helpers
        notifications: -> Notifications.find()



if Meteor.isServer
    publishComposite 'received_notifications', ->
        {
            find: ->
                Notifications.find {}
                    # recipient_id: Meteor.userId()
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.author_id
                    }
                ]    
        }
        
