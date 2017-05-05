FlowRouter.route '/course/:slug/module/:module_number', 
    name:'route_home'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_sections'


FlowRouter.route '/course/:slug/module/:module_number/section/:section_number', 
    name:'section'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'view_section'

FlowRouter.route '/course/:slug/module/:module_number/lightwork', 
    name: 'module_lightwork'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_lightwork'
    
FlowRouter.route '/course/:slug/module/:module_number/', 
    triggersEnter: [ (context, redirect) ->
        redirect "/course/#{context.params.slug}/module/#{context.params.module_number}/section/1"
    ]
    



Template.view_module.onCreated ->
    @autorun -> Meteor.subscribe 'module', course=FlowRouter.getParam('slug'), module_number=parseInt FlowRouter.getParam('module_number')



Template.view_module.helpers

    is_first_module: ->
        parseInt FlowRouter.getParam('module_number') is 1

    module: -> 
        Docs.findOne 
            number: parseInt FlowRouter.getParam('module_number')
            course: FlowRouter.getParam('slug')
    course: -> 
        Docs.findOne 
            slug:FlowRouter.getParam('slug')
    module_sections: ->
        Docs.find {
            type: 'section'
            module_number: parseInt FlowRouter.getParam('module_number')
            lightwork: $ne: true

        }, sort: number: 1

    # section_path_class: ->
        # Tracker.autorun =>
        #     section_path_class = ''
        #     # console.log @
        #     FlowRouter.watchPathChange()
        #     path = FlowRouter.current().path
        #     module_number = parseInt FlowRouter.getParam('module_number')
        #     # section_number = parseInt FlowRouter.getParam('section_number')
        #     if path is "/course/sol/module/#{module_number}/section/#{@number}"
        #         # console.log 'active', @number
        #         # console.log path
        #         section_path_class = 'active' 
        #     else
        #         # console.log 'not active', @number
        #         # console.log path
        #         section_path_class = '' 
        #     # console.log 'final path', section_path_class        
        #     return section_path_class
        # return section_path_class

    # section_path_class2: ->
    #     "{{isActiveRoute '/course/#{../course}/module/#{module_number}/section/#{number}'}}"

    section_path_class: ->
        module_number = parseInt FlowRouter.getParam('module_number')

        if @ is module_number then 'active' else ''
        


Template.view_module.events
    'click .edit': ->
        module_number = FlowRouter.getParam('module_number')
        slug = FlowRouter.getParam('slug')
        FlowRouter.go "/course/#{slug}/module/#{module_number}/edit"


Template.view_section.onCreated ->
    @autorun -> Meteor.subscribe 'section', course=FlowRouter.getParam('slug'), module_number=parseInt FlowRouter.getParam('module_number'), section_number=parseInt FlowRouter.getParam('section_number')



Template.view_section.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000


# Template.module_lightwork.onRendered ->
#     @autorun -> Meteor.subscribe 'module_lightwork', FlowRouter.getParam('module_number')

            
            
Template.view_section.helpers
    section_doc: ->
        Docs.findOne 
            number: parseInt FlowRouter.getParam('section_number')
            # module_number: parseInt FlowRouter.getParam('module_number')
            type: 'section'
            # lightwork: false


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
        