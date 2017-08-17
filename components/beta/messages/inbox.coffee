if Meteor.isClient
    FlowRouter.route '/messages', 
        name: 'messages'
        triggersEnter: [ (context, redirect) ->
            # console.log context
            redirect "/messages/inbox"
        ]
   
    FlowRouter.route '/messages/inbox', 
        name: 'inbox'
        action: (params) ->
            BlazeLayout.render 'messages_layout',
                # sub_nav: 'account_nav'
                # sub_nav: 'member_nav'
                message_content: 'inbox'

    # Template.inbox.onCreated ->
    #     @autorun -> Meteor.subscribe('inbox')
        
    Template.inbox.helpers
        received_messages: ->
            Messages.find
                recipient_id: Meteor.userId()  
    
    
            
    Template.inbox.events
       
        'click .mark_read': ->
            Docs.update @_id,
                $set: read: true
            
            
        'click .mark_unread': ->
            Docs.update @_id,
                $set: read: false
            

# if Meteor.isServer
#     Meteor.publish 'inbox', ->
#         Messages.find
#             recipient_id: @userId
