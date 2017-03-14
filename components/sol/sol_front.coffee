if Meteor.isClient
    Template.sol_front.onCreated -> 
        Template.instance().checkout = StripeCheckout.configure(
            key: Meteor.settings.public.stripe.testPublishableKey
            # image: 'https://tmc-post-content.s3.amazonaws.com/ghostbusters-logo.png'
            locale: 'auto'
            # zipCode: true
            token: (token) ->
                # console.log token
                # product = Docs.findOne FlowRouter.getParam('doc_id')
                # console.log product
                charge = 
                    amount: 10000
                    currency: 'usd'
                    source: token.id
                    description: token.description
                    receipt_email: token.email
                Meteor.call 'processPayment', charge, (error, response) ->
                    if error then Bert.alert error.reason, 'danger'
                    else
                        Meteor.users.update Meteor.userId(),
                            $addToSet: courses: 'sol'
                        Bert.alert 'Thanks for your payment.', 'success'
                        FlowRouter.go "/profile/edit/#{Meteor.userId()}"
            # closed: ->
            #     alert 'closed'

              # We'll pass our token and purchase info to the server here.
        )
        
        
    Template.sol_front.events
        'click #buy_sol': ->
            if Meteor.userId() 
                Template.instance().checkout.open
                    name: 'Source of Light'
                    # description: @description
                    amount: 10000
                    bitcoin: true
            else FlowRouter.go '/sign-in'

