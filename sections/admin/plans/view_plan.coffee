if Meteor.isClient
    Template.view_plan.helpers

                
    Template.view_plan.events


    # Template.stripe_cc_form.onCreated ->
    #     if Meteor.isDevelopment
    #         stripe_key = Meteor.settings.public.stripe.testPublishableKey
    #         # console.log 'using test key'
    #     else if Meteor.isProduction
    #         stripe_key = Meteor.settings.public.stripe.livePublishableKey
    #     else 
    #         console.log 'not dev or prod'
    #     console.log Stripe
