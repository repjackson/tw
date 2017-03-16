FlowRouter.route '/course/view/:course_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_course'


if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun ->
            Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.buy_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.view_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
        
        in_course: ->
            Meteor.user()?.courses and @_id in Meteor.user().courses
    
    Template.course_dashboard.helpers
        modules: -> 
            Modules.find { },
                sort: module_number: 1

    
    Template.buy_course.helpers
        course: ->
            Courses.findOne FlowRouter.getParam('course_id')
    
    Template.buy_course.events
        'click .buy_course': ->
            Session.set 'cart_item', @_id
            FlowRouter.go '/cart'

    
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


if Meteor.isServer
    Meteor.methods 
        enroll: (course_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: course_id
