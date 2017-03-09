FlowRouter.route '/course/view/:course_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_course'


if Meteor.isClient
    Template.view_course.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'course', FlowRouter.getParam('course_id')
    

    
    Template.view_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
        
        in_course: ->
            Meteor.user()?.courses and @title in Meteor.user().courses
    
    
    Template.buy_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
    

    
    Template.view_course.events
        'click #mark_as_complete': ->
            Courses.update FlowRouter.getParam('course_id'),
                $set: complete: true
            
        'click #mark_as_incomplete': ->
            Courses.update FlowRouter.getParam('course_id'),
                $set: complete: false
    
        'click .edit': ->
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/edit/#{course_id}"


