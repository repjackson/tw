if Meteor.isClient
    FlowRouter.route '/messages/archived', 
        name: 'archived'
        action: (params) ->
            BlazeLayout.render 'messages_layout',
                message_content: 'archived_messages'

    # Template.archived_messages.onCreated ->
    #     @autorun -> Meteor.subscribe('archived_messages')
        
    Template.archived_messages.helpers
        archived_messages: ->
            Messages.find
                author_id: Meteor.userId()  
                archived: true
    
            
    Template.archived_messages.events

# if Meteor.isServer
#     Meteor.publish 'archived_messages', ->
#         Messages.find
#             author_id: Meteor.userId()
