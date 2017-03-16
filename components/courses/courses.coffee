@Courses = new Meteor.Collection 'courses'


FlowRouter.route '/courses', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'courses'


Meteor.users.helpers
    course_ob: -> 
        Courses.find
            _id: $in: @courses




if Meteor.isClient
    Template.courses.onCreated -> 
        @autorun -> Meteor.subscribe('courses')

    Template.courses.helpers
        courses: -> 
            Courses.find { }
    
        in_course: ->
            # console.log @_id
            @_id in Meteor.user().courses
    

    Template.courses.events
        'click .edit': -> FlowRouter.go("/course/edit/#{@_id}")
            
        'click #add_course': ->
            id = Courses.insert({})
            FlowRouter.go "/course/edit/#{id}"
    
    

        

if Meteor.isServer
    Courses.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'courses', ()->
    
        self = @
        match = {}
        Courses.find match
    
    Meteor.publish 'course', (id)->
        Courses.find id
    
