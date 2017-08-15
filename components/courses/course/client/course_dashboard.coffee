FlowRouter.route '/course/sol/dashboard', 
    name: 'course_dashboard'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_dashboard'




Template.course_dashboard.onRendered ->
    Meteor.setTimeout ->
        $('#course_dashboard_menu .item').tab()
    , 1000


Template.course_dashboard.helpers
        
        
Template.course_dashboard.events