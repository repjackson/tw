FlowRouter.route '/course/:course_slug/module/:module_number/downloads', 
    name: 'module_files'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_files_page'



Template.module_files_page.onCreated ->
    @autorun -> Meteor.subscribe 'module_downloads', FlowRouter.getParam('course_slug'),FlowRouter.getParam('module_number')


Template.module_files_page.helpers
    module_ob: -> 
        module_ob = Modules.findOne
            number: parseInt FlowRouter.getParam('module_number')
        module_ob
