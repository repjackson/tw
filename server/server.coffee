Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        true
        # # console.log 'user ' + userId + 'wants to modify doc' + doc._id
        # if userId and doc._id == userId
        #     # console.log 'user allowed to modify own account'
        #     true

# Kadira.connect('Dmhg2hdSobHy3fXWE', '940bb181-70ce-42c4-a557-77696e5da41d')



Meteor.publish 'userStatus', ->
    Meteor.users.find { 'status.online': true }, 
        fields: 
            points: 1
            tags: 1
            
            
            
Meteor.publish 'user_status_notification', ->
    Meteor.users.find('status.online': true).observe
        added: (id) ->
            console.log "#{id} just logged in"
        removed: (id) ->
            console.log "#{id} just logged out"


Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.cloudinary_key
    api_secret: Meteor.settings.cloudinary_secret


if Meteor.isDevelopment
    secret_key = Meteor.settings.private.stripe.testSecretKey
    # console.log 'using test secret key'
else if Meteor.isProduction
    secret_key = Meteor.settings.private.stripe.liveSecretKey
else 
    console.log 'not dev or prod'

Stripe = StripeAPI(secret_key)
Meteor.methods
    processPayment: (charge) ->
        handleCharge = Meteor.wrapAsync(Stripe.charges.create, Stripe.charges)
        payment = handleCharge(charge)
        # console.log payment
        payment



Accounts.onCreateUser (options, user) ->
    user.courses = []
    user.tests = []
    return user

# AccountsMeld.configure
#     askBeforeMeld: false
#     # meldDBCallback: meldDBCallback
#     # serviceAddedCallback: serviceAddedCallback