Accounts.emailTemplates.siteName = "The Way"
Accounts.emailTemplates.from     = "The Way Admin <no-reply@theway.world>"

Accounts.emailTemplates.verifyEmail =
    subject: () ->
        return "The Way Email Verification"
 
    text: ( user, url )->
        emailAddress   = user.emails[0].address
        urlWithoutHash = url.replace( '#/', '' )
        supportEmail   = "support@theway.world"
        emailBody      = "To verify your email address (#{emailAddress}) visit the following link:\n\n#{urlWithoutHash}\n\n If you did not request this verification, please ignore this email. If you feel something is wrong, please contact our support team: #{supportEmail}."
        return emailBody
