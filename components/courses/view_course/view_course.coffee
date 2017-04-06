FlowRouter.route '/course/:course_id', action: (params) ->
    BlazeLayout.render 'view_course',
        course_content: 'course_welcome'

FlowRouter.route '/course/:course_id/modules', action: (params) ->
    BlazeLayout.render 'view_course',
        course_content: 'course_modules'

FlowRouter.route '/course/:course_id/members', action: (params) ->
    BlazeLayout.render 'view_course',
        course_content: 'course_members'

FlowRouter.route '/course/:course_id/downloads', action: (params) ->
    BlazeLayout.render 'view_course',
        course_content: 'course_downloads'

FlowRouter.route '/course/:course_id/welcome', action: (params) ->
    BlazeLayout.render 'view_course',
        course_content: 'course_welcome'


if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.view_course.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
        
        in_course: -> Meteor.user()?.courses and @_id in Meteor.user().courses
    
    # Template.course_modules.onCreated ->
        # @autorun -> Meteor.subscribe 'course_modules', FlowRouter.getParam('course_id')
    Template.course_modules.helpers
        module_docs: -> 
            Modules.find { 
                course_id: course_id
                },
                sort: module_number: 1
            
            
    
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