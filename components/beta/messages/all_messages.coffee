if Meteor.isClient
    FlowRouter.route '/messages/all', 
        name: 'all'
        action: (params) ->
            BlazeLayout.render 'messages_layout',
                message_content: 'all_messages'

    # Template.all_messages.onCreated ->
    #     @autorun -> Meteor.subscribe('all_messages')
        
    Template.all_messages.helpers
        all_messages: ->
            Messages.find
                author_id: Meteor.userId()  
    
    
            
    Template.all_messages.events
        # 'click .mark_read': ->
        #     Docs.update @_id,
        #         $set: read: true
            
            
        # 'click .mark_unread': ->
        #     Docs.update @_id,
        #         $set: read: false
            

# if Meteor.isServer
#     Meteor.publish 'all_messages', ->
#         Messages.find
#             author_id: Meteor.userId()
