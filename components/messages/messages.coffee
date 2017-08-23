@Messages = new Meteor.Collection 'messages'
Messages.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.status = 'draft'
    doc.read = false
    doc.archived = false
    return

Messages.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    recipient: -> Meteor.users.findOne @recipient_id
    parent: -> Messages.findOne @parent_id

if Meteor.isClient
    Template.messages_layout.onCreated ->
        @autorun -> Meteor.subscribe('sent_messages')
        @autorun -> Meteor.subscribe('received_messages')


    Template.messages_layout.events
        'click #compose': (e,t)->
            message_id = Messages.insert({})
            FlowRouter.go "/message/edit/#{message_id}"

    
    Template.messages_layout.helpers
        unread_inbox_count: ->
            Messages.find(
                recipient_id: Meteor.userId()
                archived: false
                status: 'sent'
                read: false
                ).count()
    
        sent_count: ->
            Messages.find(
                author_id: Meteor.userId()
                status: 'sent'
                ).count()
    
        drafts_count: ->
            Messages.find(
                author_id: Meteor.userId()
                status: 'draft'
                ).count()
    
        archived_count: ->
            Messages.find(
                $or: [
                    author_id: Meteor.userId()
                    recipient_id: Meteor.userId()
                    ]
                archived: true
                ).count()
    
    
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
    Meteor.publish 'messages_with_user', (recipient_id)->
        Messages.find
            recipient_id: recipient_id
            author_id: Meteor.userId()
            
    Meteor.publish 'message', (message_id)->
        Messages.find message_id
            
            
    Meteor.publish 'unread_messages', ()->
        Messages.find
            recipient_id: Meteor.userId()
            read: false
            
    publishComposite 'received_messages', ->
        {
            find: ->
                Messages.find
                    recipient_id: Meteor.userId()
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.author_id
                    }
                ]    
        }

    
    publishComposite 'sent_messages', ->
        {
            find: ->
                Messages.find
                    author_id: Meteor.userId()
            children: [
                { find: (message) ->
                    Meteor.users.find 
                        _id: message.recipient_id
                    }
                ]    
        }

    
            
    Messages.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId or doc.recipient_id is userId
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId or doc.recipient_id is userId
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId or doc.recipient_id is userId
