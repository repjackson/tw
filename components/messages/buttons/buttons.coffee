if Meteor.isClient
    Template.message_reply_button.events
        'click .reply_to_message': ->
            console.log @
            
            new_message_id = 
                Messages.insert
                    parent_id: @_id
                    recipient_id: @author_id
            FlowRouter.go "/message/edit/#{new_message_id}"
            
    Template.message_reply_button.helpers