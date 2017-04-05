FlowRouter.route '/course/:course_id/module/:doc_id/view', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_module'


if Meteor.isClient
    Template.view_module.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('course_id')
    
    
    Template.view_module.helpers
        module: -> Docs.findOne FlowRouter.getParam('doc_id')
        course: -> Docs.findOne FlowRouter.getParam('course_id')

    
    Template.view_module.events
        'click .edit': ->
            module_id = FlowRouter.getParam('doc_id')
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/#{course_id}/module/#{module_id}/edit"
