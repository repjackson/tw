FlowRouter.route '/course/:course_id/module/:module_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_module'


if Meteor.isClient
    Template.view_module.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')
    
    
    Template.view_module.helpers
        module: -> Modules.findOne FlowRouter.getParam('module_id')
        course: -> Courses.findOne FlowRouter.getParam('course_id')

    
    Template.view_module.events
        'click .edit': ->
            module_id = FlowRouter.getParam('module_id')
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/#{course_id}/module/#{module_id}/edit"
