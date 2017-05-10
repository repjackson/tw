FlowRouter.route '/course/:course_slug/module/:module_number/downloads', 
    name: 'module_downloads'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_downloads'



Template.module_downloads.onCreated ->
    @autorun -> Meteor.subscribe 'module_downloads', FlowRouter.getParam('course_slug'),FlowRouter.getParam('module_number')


Template.module_downloads.helpers
    module_ob: -> 
        module_ob = Modules.findOne
            number: parseInt FlowRouter.getParam('module_number')
        module_ob
