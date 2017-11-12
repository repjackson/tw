Meteor.methods 
    add_doc: (tags) ->
        result = Docs.insert
            tags: tags
        console.log result
                
    calculate_child_count: (doc_id)->
        child_count = Docs.find(parent_id: doc_id).count()
        Docs.update doc_id, 
            $set: child_count: child_count
        
      
                
    update_username:  (username) ->
        userId = Meteor.userId()
        if not userId
            throw new Meteor.Error(401, "Unauthorized")
        Accounts.setUsername(userId, username)
        return "Updated Username: #{username}"
        
        
    update_email: (new_email) ->
        userId = Meteor.userId();
        if !userId
            throw new Meteor.Error(401, "Unauthorized");
        Accounts.addEmail(userId, new_email);
        return "Updated Email to #{new_email}"
        
        
        
    # send_new_message_email: (user_id, message_id) ->
    #     user = Meteor.users.findOne user_id
    #     message = Messages.findOne message_id
    #     console.log "Sending new message email #{user.username}"
    #     SSR.compileTemplate 'message_email', Assets.getText('emailTemplates/message_email.html')
    #     email_data = 
    #         registrationFullName: device.adminName
    #         climberName: device.climberName
    #         adminemail_address: device.adminemail_address
    #     Meteor.defer ->
    #         Email.send
    #             to: "<#{email_address}>"
    #             from: 'Versaclimber'
    #             subject: 'Versaclimber Administration Invitation`'
    #             html: SSR.render('message_email', email_data)


    verify_email: (user_id)->
        Accounts.sendVerificationEmail(user_id)        
        
        