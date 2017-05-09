FlowRouter.route '/course/:slug/modules', 
    name: 'course_modules'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_modules'

Template.course_modules.onCreated ->
    @autorun -> Meteor.subscribe 'course_modules', FlowRouter.getParam('slug')



Template.course_modules.helpers
    modules: -> Modules.find { }, sort: number: 1
        
    module_is_available: ->
        # if 'sol_demo' in Meteor.user().courses  or 'sol_demo' in Meteor.user().roles and @number < 2
        #     return true
        if 'sol' in Meteor.user()?.courses and @number < 2
            return true
        else if 'admin' in Meteor.user().roles 
            return true
        else 
            return false

