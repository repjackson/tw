if Meteor.isClient
    Template.contact.events
        'click #send_contact_submission': ->
            name = $('#name').val()
            email = $('#email').val()
            message = $('#message').val()
            
            
            Meteor.call 'submit_contact_submission', name, email, message, ->
                swal {
                    title: "Submitted contact form thing."
                    # text: 'You will not be able to recover this imaginary file!'
                    type: 'success'
                    animation: true
                    showCancelButton: false
                    # confirmButtonColor: '#DD6B55'
                    confirmButtonText: 'Cool'
                    closeOnConfirm: true
                }
                $('#name').val('')
                $('#email').val('')
                $('#message').val('')
            
        'click #newsletter_signup': ->
            email = $('#newsletter_email').val()
            console.log email
            
            Meteor.call 'submit_newsletter_subscription', email, ->
                swal {
                    title: "Submitted #{email} for newsletter."
                    # text: 'You will not be able to recover this imaginary file!'
                    type: 'success'
                    animation: true
                    showCancelButton: false
                    # confirmButtonColor: '#DD6B55'
                    confirmButtonText: 'Cool'
                    closeOnConfirm: true
                }
                $('#newsletter_email').val('')
            
if Meteor.isServer
    Meteor.methods
        'submit_contact_submission': (name, email, message)->
            Submissions.insert
                name: name
                email: email
                message: message
            
        'submit_newsletter_subscription': (email)->
            NewsletterSubscriptions.insert
                email: email
            
            