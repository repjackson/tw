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
  
  
    Template.send_message.events
        'click #submit_new_message': ->
            username = FlowRouter.getParam('username')
            message_text = $('#new_message_body').val()
            # console.log username
            # console.log message_text
            Docs.insert
                tags: ['message']
                recipient_username: username
                read: false
                body: message_text
            $('#new_message_body').val('')
                
            
    Template.message.events
        'click .mark_read': ->
            Docs.update @_id,
                $set: read: true
            
            
        'click .mark_unread': ->
            Docs.update @_id,
                $set: read: false
            
            
            
if Meteor.isServer
    Meteor.publish 'messages_with_user', (username)->
        Docs.find
            tags: $in: ['message']
            recipient_username: username
            author_id: @userId
            
    Meteor.publish 'my_sent_messages', ->
        Docs.find
            tags: $in: ['message']
            author_id: @userId
            
    Meteor.publish 'my_received_messages', ->
        Docs.find
            tags: $in: ['message']
            parent_id: @userId
            
            
            