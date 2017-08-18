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
        if Meteor.user() and Roles.userIsInRole(Meteor.userId(), 'sol_member') or Roles.userIsInRole(Meteor.userId(), 'sol_demo')
            redirect "/course/sol/dashboard"
        else 
            redirect "/course/sol/sales"
    ]





# FlowRouter.route '/course/:slug/reminders', 
#     name: 'course_reminders'
#     action: (params) ->
#         BlazeLayout.render 'view_course',
#             course_content: 'course_reminders'

FlowRouter.route '/register-sol', 
    name: 'register-sol'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'register_sol'



Template.view_course.onCreated ->
    @autorun -> Meteor.subscribe 'doc_by_tags', ['course','sol']
    @autorun -> Meteor.subscribe 'sol_members', selected_course_member_tags.array()
    @autorun -> Meteor.subscribe 'sol_signers'
    @autorun -> Meteor.subscribe 'sol_progress'


Template.view_course.onRendered ->
    self = @
    if @subscriptionsReady()
        @autorun =>
        # console.log Session.get 'section_number'
            Meteor.setTimeout ->
                # $('.ui.accordion').accordion()            
                sol_progress_doc =  Docs.findOne(tags: $all: ["sol", "course progress"])
                # console.log sol_progress_doc
                if sol_progress_doc
                    $('#sol_percent_complete_bar').progress(
                        percent: sol_progress_doc.sol_progress_percent
                        autoSuccess: false
                        );
            , 1000


Template.view_course.helpers
    course: -> Docs.findOne tags: ['course','sol']
    
    has_agreed: ->
        course = Docs.findOne tags: ['course', 'sol']
        if course
            _.where(course.agreements, user_id: Meteor.userId() )

    sol_progress_doc: ->
        Docs.findOne(tags: $all: ["sol", "course progress"])
        

Template.view_course.events
    # 'click #add_module': ->
    #     slug = FlowRouter.getParam('slug')
    #     new_module_id = Modules.insert
    #         parent_course_slug:slug 
    #     FlowRouter.go "/course/#{slug}/module/#{new_module_id}/edit"
            
    'click #calculate_sol_progress': ->
        Meteor.call 'calculate_sol_progress', (err, res)->
            $('#sol_percent_complete_bar').progress('set percent', res);
