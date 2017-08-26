if Meteor.isClient
    Template.delete_notification_link.events
        'click #delete_notification': (e,t)->
            self = @
            swal {
                title: 'Delete notification?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, =>
                Meteor.setTimeout ->
                    $(e.currentTarget).closest('.notification_segment').transition('fade left', '1000ms')
                    Meteor.setTimeout ->
                        Notifications.remove self._id
                    , 3000
                , 1000

