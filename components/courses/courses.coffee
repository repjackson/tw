@Courses = new Meteor.Collection 'courses'

Courses.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Courses.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()






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
        courses: -> Courses.find {}
    
        in_course: ->
            # console.log @_id
            @_id in Meteor.user()?.courses
    

    Template.courses.events
        'click .edit': -> FlowRouter.go("/course/#{@_id}/edit")
            
        'click #add_course': ->
            id = Courses.insert {}
            FlowRouter.go "/course/#{id}/edit"
            
            

if Meteor.isServer
    Courses.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    publishComposite 'course', (course_id)->
        {
            find: ->
                Courses.find course_id
            children: [
                { find: (course) ->
                    Modules.find
                        course_id: course_id
                    children: [
                        {
                            find: (module) ->
                                Sections.find module.section_id
                        }
                    ]    
                }
                {
                    find: (course) ->
                        Meteor.users.find course.author_id
                }
            ]
        }            
        
    Meteor.publish 'courses', ->
        self = @
        match = {}
        if not @userId or not Roles.userIsInRole(@userId, ['admin'])
            match.published = true
                
        Courses.find match