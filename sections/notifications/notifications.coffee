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
        @notification_view_mode = new ReactiveVar('all')

    Template.notifications.helpers
        notifications: -> 
            if Template.instance().notification_view_mode.get() is 'unread'
                Notifications.find {
                    read_by: $nin: [Meteor.userId()]
                    }, 
                    sort: timestamp: -1
            else        
                Notifications.find {
                    }, 
                    sort: timestamp: -1
        
        viewing_unread: -> Template.instance().notification_view_mode.get() is 'unread'  
        viewing_all: -> Template.instance().notification_view_mode.get() is 'all'  

        
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
        
        'click #mark_all_read': ->
            if confirm 'Mark all notifications read?'
                Notifications.update {},
                    $addToSet: read_by: Meteor.userId()
                    
        'click #view_unread_notifications': (e,t)-> t.notification_view_mode.set('unread')    
        'click #view_all_notifications': (e,t)-> t.notification_view_mode.set('all')    
        
    Template.notification.helpers
        notification_segment_class: -> if Meteor.userId() in @read_by then 'basic' else ''
        read: -> Meteor.userId() in @read_by
        liked: -> Meteor.userId() in @liked_by
        
        read_count: -> @read_by.length    
        liked_count: -> @liked_by.length    
        
        subject_name: -> if @subject_id is Meteor.userId() then 'You' else @subject().name()
        object_name: -> if @object_id is Meteor.userId() then 'you' else @object().name()

    Template.notification.events
        'click .mark_read': (e,t)-> 
            $(e.currentTarget).closest('.notification_segment').transition('bounce')
            Notifications.update @_id, $addToSet: read_by: Meteor.userId()
        
        'click .mark_unread': (e,t)-> 
            $(e.currentTarget).closest('.notification_segment').transition('bounce')
            Notifications.update @_id, $pull: read_by: Meteor.userId()

        'click .like': -> Notifications.update @_id, $addToSet: liked_by: Meteor.userId()
        'click .unlike': -> Notifications.update @_id, $pull: liked_by: Meteor.userId()

        
        'click .delete_notfication': (e,t)-> 
            if confirm 'Delete Notification?'
                $(e.currentTarget).closest('.notification_segment').transition('fade left', '1000ms')
                Meteor.setTimeout ->
                    Notifications.remove @_id
                , 3000
    

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
        
        
    Meteor.publish 'notification_subjects', (selected_subjects)->
        self = @
        match = {}
        
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        
        cloud = Notifications.aggregate [
            { $match: match }
            { $project: subject_id: 1 }
            { $group: _id: '$subject_id', count: $sum: 1 }
            { $match: _id: $nin: selected_subjects }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (notification_subject, i) ->
            self.added 'notification_subjects', Random.id(),
                name: notification_subject.name
                count: notification_subject.count
                index: i
    
        self.ready()
            
    
    # Meteor.publish 'usernames', (selectedTags, selectedUsernames, pinnedUsernames, viewMode)->
# Meteor.publish 'usernames', (selectedTags)->
    # self = @

    # match = {}
    # if selectedTags.length > 0 then match.tags = $all: selectedTags
    # # if selectedUsernames.length > 0 then match.username = $in: selectedUsernames

    # cloud = Docs.aggregate [
    #     { $match: match }
    #     { $project: username: 1 }
    #     { $group: _id: '$username', count: $sum: 1 }
    #     { $match: _id: $nin: selectedUsernames }
    #     { $sort: count: -1, _id: 1 }
    #     { $limit: 50 }
    #     { $project: _id: 0, text: '$_id', count: 1 }
    #     ]

    # cloud.forEach (username) ->
    #     self.added 'usernames', Random.id(),
    #         text: username.text
    #         count: username.count
    # self.ready()

        

    Notifications.allow
        insert: (userId, doc) -> userId
        update: (userId, doc) -> userId
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
