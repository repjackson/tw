@Courses = new Meteor.Collection 'courses'


FlowRouter.route '/courses', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'courses'

if Meteor.isClient
    Template.courses.onCreated -> 
        @autorun -> Meteor.subscribe('courses')

        Template.instance().checkout = StripeCheckout.configure(
            key: Meteor.settings.public.stripe.testPublishableKey
            # image: 'https://tmc-post-content.s3.amazonaws.com/ghostbusters-logo.png'
            locale: 'auto'
            # zipCode: true
            token: (token) ->
                # console.log token
                product = Docs.findOne FlowRouter.getParam('doc_id')
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
            # closed: ->
            #     alert 'closed'

              # We'll pass our token and purchase info to the server here.
        )


    Template.courses.helpers
        courses: -> 
            Courses.find { }
    
        in_course: ->
            Meteor.user()?.courses and 'sol' in Meteor.user().courses
    

    Template.courses.events
        'click .edit': -> FlowRouter.go("/course/edit/#{@_id}")
        
        
        'click #buy_sol': ->
            Template.instance().checkout.open
                name: 'Source of Light'
                # description: @description
                amount: 10000
                bitcoin: true

        

    Template.courses.events
        # 'click #add_module': ->
        #     id = courses.insert({})
        #     FlowRouter.go "/edit_module/#{id}"
    
    


if Meteor.isServer
    Courses.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'courses', ()->
    
        self = @
        match = {}
        # selected_tags.push current_herd
        # match.tags = $all: selected_tags
        # if selected_tags.length > 0 then match.tags = $all: selected_tags

        

        Courses.find match
    
    Meteor.publish 'course', (id)->
        Courses.find id
    
