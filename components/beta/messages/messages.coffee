@Messages = new Meteor.Collection 'messages'
Messages.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return

Messages.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    recipient: -> Meteor.users.findOne @recipient


if Meteor.isClient
    FlowRouter.route '/messages', 
        name: 'messages'
        action: (params) ->
            BlazeLayout.render 'layout',
                # sub_nav: 'account_nav'
                # sub_nav: 'member_nav'
                main: 'my_messages'

    Template.my_messages.onCreated ->
        @autorun -> Meteor.subscribe('my_messages')
        
    Template.my_messages.helpers
        my_messages: ->
            Docs.find
                tags: $in: ['message']
                author_id: Meteor.userId()  
    
    
            
    Template.my_messages.events
        'click #compose': (e,t)->
            message_id = Messages.insert({})
            FlowRouter.go "/message/edit/#{message_id}"
       
        'click .mark_read': ->
            Docs.update @_id,
                $set: read: true
            
            
        'click .mark_unread': ->
            Docs.update @_id,
                $set: read: false
            
            
    Template.messages_with_user.onCreated ->
        @autorun -> Meteor.subscribe('messages_with_user', FlowRouter.getParam('username'))
       
    Template.messages_with_user.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
        conversation_messages_with_user: ->
            username = FlowRouter.getParam('username')
            Docs.find
                tags: $in: ['message']
                recipient_username: username
  
  
            
if Meteor.isServer
    Meteor.publish 'messages_with_user', (username)->
        Messages.find
            recipient_username: username
            author_id: @userId
            
    Meteor.publish 'message', (message_id)->
        Messages.find message_id
            
    Meteor.publish 'my_sent_messages', ->
        Messages.find
            author_id: @userId
            
    Meteor.publish 'my_received_messages', ->
        Messages.find
            parent_id: @userId
            
            
    Messages.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
