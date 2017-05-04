if Meteor.isClient
    FlowRouter.route '/course/:slug/modules', 
        name: 'course_modules'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_modules'
    


    Template.course_modules.helpers
        modules: -> Docs.find {type: 'module' }, sort: number: 1
            
        module_is_available: ->
            if 'sol_demo' in Meteor.user().courses and @number < 2
                return true
            else if 'sol' in Meteor.user().courses 
                return true
            else if 'admin' in Meteor.user().roles 
                return true
            else 
                return false

