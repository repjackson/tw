FlowRouter.route '/courses', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'courses'


Meteor.users.helpers
    course_ob: -> 
        Courses.find
            _id: $in: @courses




if Meteor.isClient
    Template.courses.onCreated -> 
        @autorun -> Meteor.subscribe('docs', [], 'course')

    Template.courses.helpers
        courses: -> 
            Docs.find 
                type: 'course'
    
        in_course: ->
            # console.log @_id
            @_id in Meteor.user().courses
    

    Template.courses.events
        'click .edit': -> FlowRouter.go("/course/edit/#{@_id}")
            
        'click #add_course': ->
            id = Docs.insert type:'course'
            FlowRouter.go "/course/edit/#{id}"