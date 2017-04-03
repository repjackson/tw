FlowRouter.route '/course/view/:course_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_course'


if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun ->
            Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.buy_course.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.view_course.helpers
        course: ->
            Docs.findOne FlowRouter.getParam('doc_id')
        
        in_course: ->
            Meteor.user()?.courses and @_id in Meteor.user().courses
    
    Template.course_dashboard.helpers
        modules: -> 
            course_id = FlowRouter.getParam 'doc_id'
            
            Docs.find { 
                type: 'module'
                course_id: course_id
                },
                sort: module_number: 1

    
    Template.buy_course.helpers
        course: ->
            Docs.findOne FlowRouter.getParam('doc_id')
    
    Template.buy_course.events
        'click .buy_course': ->
            Session.set 'cart_item', @_id
            FlowRouter.go '/cart'

    
    Template.view_course.events
        'click #mark_as_complete': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: complete: true
            
        'click #mark_as_incomplete': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: complete: false
    
        'click .edit': ->
            course_id = FlowRouter.getParam('doc_id')
            FlowRouter.go "/course/edit/#{course_id}"


if Meteor.isServer
    Meteor.methods 
        enroll: (course_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: course_id
