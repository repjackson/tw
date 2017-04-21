FlowRouter.route '/cart',
    triggersEnter: [ AccountsTemplates.ensureSignedIn ]
    action: ->
        BlazeLayout.render 'layout',
            main: 'cart'

FlowRouter.route '/cart-profile/:user_id',
    triggersEnter: [ AccountsTemplates.ensureSignedIn ]
    action: ->
        BlazeLayout.render 'layout',
            main: 'cart_profile'


if Meteor.isClient
    Template.cart.onCreated ->
        if Meteor.isDevelopment
            stripe_key = Meteor.settings.public.stripe.testPublishableKey
        else if Meteor.isProduction
            stripe_key = Meteor.settings.public.stripe.livePublishableKey
        else 
            console.log 'not dev or prod'
        
        @autorun -> Meteor.subscribe 'cart'
        Template.instance().checkout = StripeCheckout.configure(
            key: stripe_key
            image: '/toriwebster-logomark-04.png'
            locale: 'auto'
            # zipCode: true
            token: (token) ->
                # console.log token
                course = Courses.findOne Session.get 'cart_item'
                # console.log course
                charge = 
                    amount: course.price*100
                    currency: 'usd'
                    source: token.id
                    description: token.description
                    receipt_email: token.email
                Meteor.call 'processPayment', charge, (error, response) =>
                    if error then Bert.alert error.reason, 'danger'
                    else
                        Meteor.users.update Meteor.userId(),
                            $addToSet: courses: course._id
                        Bert.alert "Thank you for your payment.  You're enrolled in #{course.title}.", 'success'
                        FlowRouter.go "/cart-profile/#{Meteor.userId()}"
            closed: ->
                Bert.alert "Payment Canceled", 'danger'
        )

    Template.cart_checkout.helpers 
        # cart_item: ->
        #     Courses.findOne Session.get 'cart_item'
        
        cart_items: ->
            Docs.find
                type: 'cart_item'
                author_id: Meteor.userId()
                
        parent_doc: -> Docs.findOne @parent_id
            
        total_items: -> Docs.find({type: 'cart_item'},{author_id: Meteor.userId()}).count()
            
        subtotal: ->    
            subtotal = 0
            cart_items = Docs.find({type: 'product'}).fetch()
            for cart_item in cart_items
                subtotal += cart_item.price
            subtotal
            
    Template.cart.events
        'click .buy_course': ->
            if @price > 0
                Template.instance().checkout.open
                    name: @title
                    description: @subtitle
                    amount: @price*100
            else
                Meteor.call 'enroll', @_id, (err,res)=>
                    if err then console.error err
                    else
                        Bert.alert "You are now enrolled in #{@title}", 'success'
                        # FlowRouter.go "/course/#{_id}"

        'click .purchase_item': ->
            parent_doc = Docs.findOne @parent_id
            if parent_doc.price > 0
                Template.instance().checkout.open
                    name: 'Tori Webster Inspires, LLC'
                    description: parent_doc.title
                    amount: parent_doc.price*100
            else
                Meteor.call 'register_purchase', @parent_id, (err,response)->
                    if err then console.error err
                    else
                        Bert.alert "Thank you for your purchase.", 'success'
                        
                    


if Meteor.isServer
    # Meteor.publish 'cart', (course_id)->
    #     Courses.find course_id
    Meteor.methods
        'add_to_cart': (doc_id)->
            Docs.insert
                type: 'cart_item'
                parent_id: doc_id
                number: 1
        
        'remove_from_cart': (doc_id)->
            Docs.remove
                type: 'cart_item'
                parent_id: doc_id
        
        'register_purchase': (product_id)->
            product = Docs.findOne product_id
            Docs.insert
                type: 'purchase'
                parent_doc: product_id
                sale_price: product.price
        
        
    publishComposite 'cart', ->
        {
            find: ->
                Docs.find
                    type: 'cart_item'
                    author_id: @userId            
            children: [
                { find: (cart_item) ->
                    Docs.find cart_item.parent_id
                    }
                ]    
        }
