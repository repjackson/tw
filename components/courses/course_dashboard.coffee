if Meteor.isClient
    Template.course_dashboard.onCreated -> 
        @autorun -> Meteor.subscribe('course_modules')

    Template.course_dashboard.helpers
        modules: -> 
            Modules.find { },
                sort: module_number: 1
    


if Meteor.isServer
    Meteor.publish 'course_modules', (course_id)->
    
        self = @
        match = {}

        Modules.find
            course_id: course_id
