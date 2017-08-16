if Meteor.isClient
    FlowRouter.route '/message/edit/:message_id', 
        name: 'message_edit'
        action: (params) ->
            BlazeLayout.render 'messages_layout',
                message_content: 'message_edit'

    Template.message_edit.onCreated ->
        @autorun -> Meteor.subscribe('usernames')
        @autorun -> Meteor.subscribe('message', FlowRouter.getParam('message_id'))
        
        
    Template.message_edit.helpers
        message: -> Messages.findOne {}
        
        
        message_edit_settings: -> {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Meteor.users
                    field: 'username'
                    matchAll: true
                    template: Template.user_pill
                }
                ]
        }
    

    Template.message_edit.events
        "autocompleteselect input": (event, template, doc) ->
            console.log("selected ", doc)
            Messages.update FlowRouter.getParam('message_id'),
                $set: recipient_id: doc._id
                
                
    
        'click #submit_new_message': ->
            username = FlowRouter.getParam('username')
            message_text = $('#new_message_body').val()
            # console.log username
            # console.log message_text
            Messages.insert
                tags: ['message']
                recipient_username: username
                read: false
                body: message_text
            $('#new_message_body').val('')
                

if Meteor.isServer
    Meteor.publish 'usernames', ->
        Meteor.users.find {},
            fields: username: 1