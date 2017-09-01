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
            Messages.find {
                recipient_id: Meteor.userId()
                archived: false
                }, sort: timestamp: -1
    
            
    Template.inbox.events
    
    Template.inbox_message.helpers
            

# if Meteor.isServer
#     Meteor.publish 'inbox', ->
#         Messages.find
#             recipient_id: @userId
