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
    
    
    Template.read_link.events
        'click .mark_read': ->
            Messages.update @_id,
                $set: read: true
            
            
        'click .mark_unread': ->
            Messages.update @_id,
                $set: read: false
    
    Template.archive_link.events
        'click .archive': (e,t)->
            self = @
            $(e.currentTarget).closest('.comment').transition('fly left')
            Meteor.setTimeout ->
                Messages.update self._id,
                    $set: archived: true
            , 500
            
        'click .unarchive': (e,t)->
            self = @
            $(e.currentTarget).closest('.comment').transition('fly right')
            Meteor.setTimeout ->
                Messages.update self._id,
                    $set: archived: false
            , 500
