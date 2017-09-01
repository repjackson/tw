if Meteor.isClient
    FlowRouter.route '/messages/drafts', 
        name: 'drafts'
        action: (params) ->
            BlazeLayout.render 'messages_layout',
                message_content: 'drafts'

    Template.drafts.onCreated ->
        @autorun -> Meteor.subscribe('drafts')
        
        
    Template.drafts.helpers
        drafts: -> Messages.find status: 'draft'
        
        
    Template.drafts.events
                

if Meteor.isServer
    Meteor.publish 'drafts', ->
        Messages.find
            status: 'draft'
            author_id: Meteor.userId()