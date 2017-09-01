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
        'click .mark_read': (e,t)->
            $(e.currentTarget).closest('.comment').transition('bounce')
            Messages.update @_id,
                $set: read: true
            
            
        'click .mark_unread': (e,t)->
            $(e.currentTarget).closest('.comment').transition('bounce')
            Messages.update @_id,
                $set: read: false
    
    Template.archive_link.events
        'click .archive': (e,t)->
            self = @
            $(e.currentTarget).closest('.comment').transition('fly left')
            Meteor.setTimeout ->
                Messages.update self._id,
                    $set: 
                        read: true
                        archived: true
            , 500
            
        'click .unarchive': (e,t)->
            self = @
            $(e.currentTarget).closest('.comment').transition('fly right')
            Meteor.setTimeout ->
                Messages.update self._id,
                    $set: archived: false
            , 500



    Template.delete_message_button.events
        'click #delete_message': ->
            self = @
            swal {
                title: 'Delete Message?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Messages.remove self._id
                FlowRouter.go '/messages'

    Template.delete_message_link.events
        'click #delete_message': ->
            self = @
            swal {
                title: 'Delete Message?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Messages.remove self._id
                FlowRouter.go '/messages'


