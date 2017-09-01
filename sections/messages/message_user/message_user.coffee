if Meteor.isClient
    Template.message_user.onCreated ->
        @sending_message = new ReactiveVar(false)

    
    Template.message_user.helpers
        sending_message: -> Template.instance().sending_message.get()
        
        
    Template.message_user.events
        'click #send_message': (e,t)->
            message_content = $('#message_content').val()
            # console.log message_content
            
            recipient = Meteor.users.findOne username: FlowRouter.getParam('username')
            Messages.insert
                recipient_id: recipient._id
                author_id: Meteor.userId()
                content: message_content
            swal {
                title: "Message to #{recipient.name()} sent."
                # text: 'You will not be able to recover this imaginary file!'
                type: 'success'
                animation: true
                showCancelButton: false
                # confirmButtonColor: '#DD6B55'
                closeOnConfirm: true
            }
            $('#message_content').val('')
            t.sending_message.set(false)
            
            
        'click #cancel_message': (e,t)->
            t.sending_message.set(false)
            
        'click #create_message': (e,t)->
            t.sending_message.set(true)
            
            