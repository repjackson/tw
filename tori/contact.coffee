if Meteor.isClient
    Template.contact.events
        'click #send_contact_submission': ->
            name = $('#name').val()
            email = $('#email').val()
            message = $('#message').val()
            
            
            Meteor.call 'submit_contact_submission', name, email, message, ->
                alert 'submitted'
                $('#name').val('')
                $('#email').val('')
                $('#message').val('')
            
if Meteor.isServer
    Meteor.methods
        'submit_contact_submission': (name, email, message)->
            Submissions.insert
                name: name
                email: email
                message: message
            
            