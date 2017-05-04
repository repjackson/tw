if Meteor.isClient
    # loggedIn = FlowRouter.group
    #     triggersEnter: [ ->
    #         unless Meteor.loggingIn() or Meteor.userId()
    #             route = FlowRouter.current()
    #         unless route.route.name is 'login'
    #             Session.set 'redirectAfterLogin', route.path
    #             FlowRouter.go 'login'
    #         ]

    
    
    
    FlowRouter.route '/course/:slug', 
        name: 'course_home'
        triggersEnter: [ (context, redirect) ->
            if 'sol' in Meteor.user().courses
                redirect "/course/#{context.params.slug}/welcome"
            else 
                redirect "/course/#{context.params.slug}/sales"
        ]
    

    
    
    
    FlowRouter.route '/course/:slug/reminders', 
        name: 'course_reminders'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_reminders'
    
    FlowRouter.route '/register-sol', 
        name: 'register-sol'
        action: (params) ->
            BlazeLayout.render 'layout',
                main: 'register_sol'



    Template.view_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('slug')
    
    Template.view_course.helpers
        course: -> 
            Docs.findOne
                type: 'course'
                slug: FlowRouter.getParam('slug')
        


    
    Template.view_course.events
        'click #add_module': ->
            slug = FlowRouter.getParam('slug')
            new_module_id = Docs.insert
                type: 'module'
                course:slug 
            FlowRouter.go "/course/#{slug}/module/#{new_module_id}/edit"
            






if Meteor.isServer
    Meteor.methods 
        enroll: (slug)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: slug