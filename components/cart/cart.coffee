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
        @autorun -> Meteor.subscribe 'cart'
        Template.instance().checkout = StripeCheckout.configure(
            key: Meteor.settings.public.stripe.livePublishableKey
            # image: 'https://tmc-post-content.s3.amazonaws.com/ghostbusters-logo.png'
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
            # closed: ->
            #     alert 'closed'
        )

    Template.cart_checkout.helpers 
        # cart_item: ->
        #     Courses.findOne Session.get 'cart_item'
        
        cart_items: ->
            Docs.find
                type: 'cart_item'
                author_id: Meteor.userId()
                
        parent_doc: ->
            Docs.findOne @parent_id
            
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


if Meteor.isServer
    # Meteor.publish 'cart', (course_id)->
    #     Courses.find course_id
    Meteor.methods
        'add_to_cart': (doc_id)->
            Docs.insert
                type: 'cart_item'
                parent_id: doc_id
                number: 1
        
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
