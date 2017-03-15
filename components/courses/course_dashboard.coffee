if Meteor.isClient
    Template.course_dashboard.onCreated -> 
        @autorun -> Meteor.subscribe('course_modules')

    Template.course_dashboard.helpers
        modules: -> 
            Modules.find { },
                sort: module_number: 1
    

    


    Template.sol.events
        'click #add_module': ->
            id = Modules.insert
                course_id: '@_id'
            FlowRouter.go "/module/edit/#{id}"




if Meteor.isServer
    Meteor.publish 'course_modules', (course_id)->
    
        self = @
        match = {}

        Modules.find
            course_id: course_id
