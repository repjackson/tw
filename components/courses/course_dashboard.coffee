if Meteor.isClient
    Template.course_modules.onCreated -> 
        @autorun -> Meteor.subscribe('course_modules')

    Template.course_modules.helpers
        modules: -> 
            course_id = FlowRouter.getParam 'course_id'
            
            Docs.find { 
                type: 'module'
                course_id: course_id
                },
                sort: module_number: 1
    