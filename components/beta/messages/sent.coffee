if Meteor.isClient
    FlowRouter.route '/messages/sent', 
        name: 'sent'
        action: (params) ->
            BlazeLayout.render 'messages_layout',
                # sub_nav: 'account_nav'
                # sub_nav: 'member_nav'
                message_content: 'sent'

    Template.sent.onCreated ->
        @autorun -> Meteor.subscribe('sent')
        
    Template.sent.helpers
        sent_messages: ->
            Messages.find
                author_id: Meteor.userId()  
    
    
            
    Template.sent.events
        # 'click .mark_read': ->
        #     Docs.update @_id,
        #         $set: read: true
            
            
        # 'click .mark_unread': ->
        #     Docs.update @_id,
        #         $set: read: false
            

if Meteor.isServer
    Meteor.publish 'sent', ->
        Messages.find
            author_id: Meteor.userId()
