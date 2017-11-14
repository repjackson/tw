Accounts.emailTemplates.siteName = "Tori Webster Inspires, LLC"
Accounts.emailTemplates.from     = "TWI Admin <no-reply@toriwebster.com>"

Accounts.emailTemplates.verifyEmail =
    subject: () ->
        return "Tori Webster Inspires, LLC Email Verification"
 
    text: ( user, url )->
        emailAddress   = user.emails[0].address
        urlWithoutHash = url.replace( '#/', '' )
        supportEmail   = "support@toriwebster.com"
        emailBody      = "To verify your email address (#{emailAddress}) visit the following link:\n\n#{urlWithoutHash}\n\n If you did not request this verification, please ignore this email. If you feel something is wrong, please contact our support team: #{supportEmail}."
        return emailBody
