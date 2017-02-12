if Meteor.isClient
    Template.billing.onCreated ->
        @autorun -> Meteor.subscribe('selected_posts', selected_tags.array())
    
    Template.billing.onCreated ->
        template = Template.instance()
        template.checkout = StripeCheckout.configure(
            key: Meteor.settings.public.stripe.testPublishableKey
            # image: 'https://tmc-post-content.s3.amazonaws.com/ghostbusters-logo.png'
            locale: 'auto'
            token: (token) ->
              # We'll pass our token and purchase info to the server here.
        )
    
    Template.billing.helpers
        posts: -> 
            Docs.find {
                type: 'post'
                },
                sort:
                    publish_date: -1
                limit: 10
                
    Template.billing.events
        'click #checkout': ->
            template = Template.instance()
            template.checkout.open
                name: 'Ghostbusting Service'
                description: 'this is the description'
                amount: 10
                bitcoin: true



