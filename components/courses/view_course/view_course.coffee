FlowRouter.route '/course/:course_id', 
    name: 'course_home'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_welcome'

FlowRouter.route '/course/:course_id/modules', 
    name: 'course_modules'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_modules'

FlowRouter.route '/course/:course_id/members', 
    name: 'course_members'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_members'

FlowRouter.route '/course/:course_id/downloads', 
    name: 'course_downloads'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_downloads'

FlowRouter.route '/course/:course_id/welcome', 
    name: 'course_welcome'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_welcome'


if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.view_course.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
        
        in_course: -> Meteor.user()?.courses and @_id in Meteor.user().courses
    


    Template.course_modules.helpers
        modules: -> Modules.find { }, sort: number: 1
            
    Template.course_welcome.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
  
    
    Template.course_welcome.events
        'click .buy_course': ->
            Session.set 'cart_item', @_id
            FlowRouter.go '/cart'

    
    Template.view_course.events
        'click #edit_course': ->
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/#{course_id}/edit"
            
        'click #add_module': ->
            course_id = FlowRouter.getParam('course_id')
            new_module_id = Modules.insert 
                course_id:course_id 
            FlowRouter.go "/course/#{course_id}/module/#{new_module_id}/edit"
            

if Meteor.isServer
    Meteor.methods 
        enroll: (course_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: course_id