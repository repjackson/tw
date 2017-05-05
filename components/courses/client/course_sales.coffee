FlowRouter.route '/course/:slug/sales', 
    name: 'course_sale_page'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'course_sales'




Template.course_sales.helpers
    in_sol: -> Roles.userIsInRole(Meteor.userId(), 'sol_member')
    in_demo: -> Roles.userIsInRole(Meteor.userId(), 'sol_demo_member')
    course: -> Docs.findOne slug:FlowRouter.getParam('slug')


Template.course_sales.onCreated ->
    @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('slug')

Template.course_sales.events
    'click #sign_up_demo': ->
        if Meteor.user()
            Roles.addUsersToRoles(Meteor.userId(), 'sol_demo')
            Meteor.users.update Meteor.userId(),
                $addToSet:
                    courses: FlowRouter.getParam 'slug'
            swal {
                title: "Thank you, #{Meteor.user().name()}."
                text: "You're now enrolled in the demo."
                type: 'success'
                animation: true
                confirmButtonText: "Continue to Course",
                closeOnConfirm: true
            }, ->
                FlowRouter.go "/course/sol/welcome"

    
        else 
            Session.set 'enrolling_in', 'sol_demo'
            FlowRouter.go '/register-sol'
            # FlowRouter.go '/sign-up'
    
    
    'click #unenroll': ->
        Roles.removeUsersFromRoles(Meteor.userId(), 'sol_demo_member')
