if Meteor.isClient
        
    FlowRouter.route '/course/:course_id/sales', 
        name: 'course_sale_page'
        action: (params) ->
            BlazeLayout.render 'layout',
                main: 'course_sales'
    

    
    
    Template.course_sales.helpers
        in_sol: -> Roles.userIsInRole(Meteor.userId(), 'sol_member')
        in_demo: -> Roles.userIsInRole(Meteor.userId(), 'sol_demo_member')
        course: -> Docs.findOne FlowRouter.getParam('course_id')


    Template.course_sales.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')

    Template.course_sales.events
        'click #sign_up_demo': ->
            if Meteor.user()
                Roles.addUsersToRoles(Meteor.userId(), 'sol_demo_member')
                Meteor.users.update Meteor.userId(),
                    $addToSet:
                        courses: FlowRouter.getParam 'course_id'
                swal {
                    title: "Thank you, #{Meteor.user().name()}."
                    text: "You're now enrolled in the demo."
                    type: 'success'
                    animation: true
                    confirmButtonText: "Continue to Course",
                    closeOnConfirm: true
                }, ->
                    FlowRouter.go "/course/sW4accx4fvZBK6wLn/welcome"

        
            else 
                Session.set 'enrolling_in', 'sol_demo'
                FlowRouter.go '/register-sol'
        
        
        'click #unenroll': ->
            Roles.removeUsersFromRoles(Meteor.userId(), 'sol_demo_member')
