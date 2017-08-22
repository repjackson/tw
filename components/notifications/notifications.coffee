@Notifications = new Meteor.Collection 'notifications'

Notifications.before.insert (user_id, doc)->
    doc.timestamp = Date.now()
    doc.read_by = []
    doc.liked_by = []
    return
    
    
Notifications.helpers
    subject: -> Meteor.users.findOne @subject_id
    object: -> Meteor.users.findOne @object_id
    when: -> moment(@timestamp).fromNow()
    
Meteor.methods
    add_notification: (subject_id, predicate, object_id) ->
        new_id = Notifications.insert
            subject_id: subject_id
            predicate: predicate
            object_id: object_id
        return new_id




            
FlowRouter.route '/notifications', action: ->
    BlazeLayout.render 'layout', 
        main: 'notifications'

if Meteor.isClient
    Template.notifications.onCreated ->
        @autorun -> Meteor.subscribe 'all_notifications'
    
    Template.notifications.helpers
        notifications: -> 
            Notifications.find {}, 
                sort: timestamp: -1
        
        # notifications_allowed: ->
        #     # console.log Notification.permission
        #     if Notification.permission is 'denied' or 'default' 
        #         # console.log 'notifications are denied'
        #         # return false
        #     if Notification.permission is 'granted'
        #         # console.log 'yes granted'
        #         # return true
            
            
    Template.notifications.events
        'click #allow_notifications': ->
            Notification.requestPermission()
        
    Template.notification.helpers
        notification_segment_class: -> if Meteor.userId() in @read_by then 'basic' else ''
        read: -> Meteor.userId() in @read_by
        liked: -> Meteor.userId() in @liked_by
        
        read_count: -> @read_by.length    
        liked_count: -> @liked_by.length    
        
        subject_name: -> if @subject_id is Meteor.userId() then 'You' else @subject().name()
        object_name: -> if @object_id is Meteor.userId() then 'you' else @object().name()

    Template.notification.events
        'click .mark_read': -> Notifications.update @_id, $addToSet: read_by: Meteor.userId()
        'click .mark_unread': -> Notifications.update @_id, $pull: read_by: Meteor.userId()

        'click .like': -> Notifications.update @_id, $addToSet: liked_by: Meteor.userId()
        'click .unlike': -> Notifications.update @_id, $pull: liked_by: Meteor.userId()



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
        
    publishComposite 'all_notifications', ->
        {
            find: ->
                Notifications.find {}
            children: [
                { find: (notification) ->
                    Meteor.users.find 
                        _id: notification.subject_id
                    }
                { find: (notification) ->
                    Meteor.users.find 
                        _id: notification.object_id
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
        insert: (userId, doc) -> userId
        update: (userId, doc) -> userId
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
