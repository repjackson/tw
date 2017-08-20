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
            author_id: Meteor.userId()
        return new_id

            
FlowRouter.route '/notifications', action: ->
    BlazeLayout.render 'layout', 
        main: 'notifications'

if Meteor.isClient
    Template.notifications.onCreated ->
        @autorun -> Meteor.subscribe 'received_notifications'
    
    Template.notifications.helpers
        notifications: -> Notifications.find()
        
        
    Template.notification.helpers
        notification_segment_class: ->
            if @read then 'basic' else ''

    Template.notification.events
        'click .mark_read': ->
            Notifications.update @_id,
                $set: read: true
            
            
        'click .mark_unread': ->
            Notifications.update @_id,
                $set: read: false



if Meteor.isServer
    publishComposite 'received_notifications', ->
        {
            find: ->
                Notifications.find 
                    recipient_id: Meteor.userId()
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.author_id
                    }
                ]    
        }
        
        
    publishComposite 'unread_notifications', ->
        {
            find: ->
                Notifications.find 
                    recipient_id: Meteor.userId()
                    read: false
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.author_id
                    }
                ]    
        }
        

    Notifications.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
