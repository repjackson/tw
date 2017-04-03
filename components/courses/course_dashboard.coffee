if Meteor.isClient
    Template.course_dashboard.onCreated -> 
        @autorun -> Meteor.subscribe('course_modules')

    Template.course_dashboard.helpers
        modules: -> 
            course_id = FlowRouter.getParam 'course_id'
            
            Docs.find { 
                type: 'module'
                course_id: course_id
                },
                sort: module_number: 1
    


if Meteor.isServer
    Meteor.publish 'course_modules', (course_id)->
    
        self = @
        match = {}

        Docs.find
            type: 'module'
            course_id: course_id
