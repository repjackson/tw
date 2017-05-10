# loggedIn = FlowRouter.group
#     triggersEnter: [ ->
#         unless Meteor.loggingIn() or Meteor.userId()
#             route = FlowRouter.current()
#         unless route.route.name is 'login'
#             Session.set 'redirectAfterLogin', route.path
#             FlowRouter.go 'login'
#         ]




FlowRouter.route '/course/:course_slug', 
    name: 'course_home'
    triggersEnter: [ (context, redirect) ->
        if Meteor.user() and Meteor.user().courses and context.params.course_slug in Meteor.user().courses
            redirect "/course/#{context.params.course_slug}/welcome"
        else 
            redirect "/course/#{context.params.course_slug}/sales"
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
    @autorun -> Meteor.subscribe 'course_by_slug', FlowRouter.getParam('course_slug')

Template.view_course.helpers
    course: -> 
        Courses.findOne
            slug: FlowRouter.getParam('course_slug')
    



Template.view_course.events
    'click #add_module': ->
        slug = FlowRouter.getParam('course_slug')
        new_module_id = Modules.insert
            parent_course_slug:slug 
        FlowRouter.go "/course/#{slug}/module/#{new_module_id}/edit"
            