Accounts.emailTemplates.siteName = "TW"
Accounts.emailTemplates.from     = "TW Admin <no-reply@toriwebster.com>"

Accounts.emailTemplates.verifyEmail =
    subject: () ->
        return "TW Email Verification"
 
    text: ( user, url )->
        emailAddress   = user.emails[0].address
        urlWithoutHash = url.replace( '#/', '' )
        supportEmail   = "support@toriwebster.com"
        emailBody      = "To verify your email address (#{emailAddress}) visit the following link:\n\n#{urlWithoutHash}\n\n If you did not request this verification, please ignore this email. If you feel something is wrong, please contact our support team: #{supportEmail}."
        return emailBody
