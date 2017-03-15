FlowRouter.route '/course/view/:course_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_course'


if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun ->
            Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.buy_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
        Template.instance().checkout = StripeCheckout.configure(
            key: Meteor.settings.public.stripe.testPublishableKey
            # image: 'https://tmc-post-content.s3.amazonaws.com/ghostbusters-logo.png'
            locale: 'auto'
            # zipCode: true
            token: (token) ->
                # console.log token
                course = Courses.findOne FlowRouter.getParam('course_id')
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
                        Bert.alert "Thanks for your payment.  You're enrolled in #{course.title}.", 'success'
                        FlowRouter.go "/profile/edit/#{Meteor.userId()}"
            # closed: ->
            #     alert 'closed'
        )


    
    Template.view_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
        
        in_course: ->
            Meteor.user()?.courses and @_id in Meteor.user().courses
    
    Template.course_dashboard.helpers
        modules: -> 
            Modules.find { },
                sort: module_number: 1

    
    Template.buy_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
    
    Template.buy_course.events
        'click .buy_course': ->
            Session.set 'cart_item', @_id
            FlowRouter.go '/cart'
            # if Meteor.userId() 
            #     if @price > 0
            #         Template.instance().checkout.open
            #             name: @title
            #             description: @subtitle
            #             amount: @price*100
            #             bitcoin: true
            #     else
            #         Meteor.call 'enroll', @_id, (err,res)=>
            #             if err then console.error err
            #             else
            #                 Bert.alert "You are now enrolled in #{@title}", 'success'
            #                 # FlowRouter.go "/course/view/#{_id}"
            # else FlowRouter.go '/sign-up'
    

    
    Template.view_course.events
        'click #mark_as_complete': ->
            Courses.update FlowRouter.getParam('course_id'),
                $set: complete: true
            
        'click #mark_as_incomplete': ->
            Courses.update FlowRouter.getParam('course_id'),
                $set: complete: false
    
        'click .edit': ->
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/edit/#{course_id}"


if Meteor.isServer
    Meteor.methods 
        enroll: (course_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: course_id
