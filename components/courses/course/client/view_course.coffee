# loggedIn = FlowRouter.group
#     triggersEnter: [ ->
#         unless Meteor.loggingIn() or Meteor.userId()
#             route = FlowRouter.current()
#         unless route.route.name is 'login'
#             Session.set 'redirectAfterLogin', route.path
#             FlowRouter.go 'login'
#         ]




FlowRouter.route '/course/sol', 
    name: 'course_home'
    triggersEnter: [ (context, redirect) ->
        if Meteor.user() and Meteor.user().courses and 'sol' in Meteor.user().courses
            redirect "/course/sol/welcome"
        else 
            redirect "/course/sol/sales"
    ]





FlowRouter.route '/course/sol/reminders', 
    name: 'course_reminders'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_reminders'

FlowRouter.route '/register-sol', 
    name: 'register-sol'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'register_sol'