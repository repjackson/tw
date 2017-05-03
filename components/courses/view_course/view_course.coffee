if Meteor.isClient
    # loggedIn = FlowRouter.group
    #     triggersEnter: [ ->
    #         unless Meteor.loggingIn() or Meteor.userId()
    #             route = FlowRouter.current()
    #         unless route.route.name is 'login'
    #             Session.set 'redirectAfterLogin', route.path
    #             FlowRouter.go 'login'
    #         ]

    
    
    
    FlowRouter.route '/course/:course_id', 
        name: 'course_home'
        triggersEnter: [ (context, redirect) ->
            if Roles.userIsInRole Meteor.user(), [ 'sol_member', 'sol_demo_member' ]
                redirect "/course/#{context.params.course_id}/welcome"
            else 
                redirect "/course/#{context.params.course_id}/sales"
        ]
    

    
    
    FlowRouter.route '/course/:course_id/modules', 
        name: 'course_modules'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_modules'
    
    FlowRouter.route '/course/:course_id/members', 
        name: 'course_members'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_members'
    
    
    FlowRouter.route '/course/:course_id/reminders', 
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
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.view_course.helpers
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        

    Template.course_modules.helpers
        modules: -> Docs.find {type: 'module' }, sort: number: 1
            
        module_is_available: ->
            if Roles.userIsInRole(Meteor.userId(), ['sol_demo_member']) and @number < 2
                return true
            else if Roles.userIsInRole(Meteor.userId(), ['admin', 'sol_member'])
                return true
            else 
                return false


    
    Template.view_course.events
        'click #add_module': ->
            course_id = FlowRouter.getParam('course_id')
            new_module_id = Docs.insert
                type: 'module'
                course_id:course_id 
            FlowRouter.go "/course/#{course_id}/module/#{new_module_id}/edit"
            





    Template.course_members.onCreated ->
        @autorun -> Meteor.subscribe 'sol_members'
        

    Template.course_members.helpers
        course_members: ->
            Meteor.users.find
                roles: $in: ['sol_member', 'sol_demo_member']

if Meteor.isServer
    Meteor.methods 
        enroll: (course_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: course_id
                
    Meteor.publish 'sol_members', (course_id) ->
        Meteor.users.find
            roles: $in: ['sol_member', 'sol_demo_member']