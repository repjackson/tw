FlowRouter.route '/course/:course_slug/module/:module_number/lightwork', 
    name: 'module_lightwork'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_lightwork'



Template.module_lightwork.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000


            
Template.module_lightwork.helpers
    lightwork_doc: ->
        module_number = parseInt FlowRouter.getParam 'module_number'
        doc = Docs.findOne 
            lightwork: true
            type: 'section'
            module_number: module_number
            
        doc
        