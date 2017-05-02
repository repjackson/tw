FlowRouter.route '/course/:course_id/module/:module_id', 
    name:'route_home'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_sections'

FlowRouter.route '/course/:course_id/module/:module_id/', 
    name:'module_sections'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_sections'

FlowRouter.route '/course/:course_id/module/:module_id/section/:section_id', 
    name:'section'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'view_section'

FlowRouter.route '/course/:course_id/module/:module_id/lightwork', 
    name: 'module_lightwork'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_lightwork'
    

if Meteor.isClient
    Template.view_module.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')
    
    Template.module_sections.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')
    
    Template.module_sections.onRendered ->
        Meteor.setTimeout ->
            $('#section_menu .item').tab()
        , 1000
    
        Meteor.setTimeout ->
            $.tab('change tab', 'tab1')
            $('[data-tab~="tab1"]').addClass( "active" )
        , 1500
    


    Template.view_module.helpers
        module: -> Docs.findOne FlowRouter.getParam('module_id')
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        sections: ->
            Docs.find {
                type: 'section'
                module_id: FlowRouter.getParam('module_id')
                lightwork: $ne: true

            }, sort: number: 1

        section_path_class: ->
            # console.log FlowRouter.current()
            section_path_class = ''
            # console.log @
            Tracker.autorun =>
                FlowRouter.watchPathChange()
                path = FlowRouter.current().path
                if path is "/course/sW4accx4fvZBK6wLn/module/#{@module_id}/section/#{@_id}"
                    console.log 'active'
                    section_path_class = 'active' 
                else
                    console.log 'not active'
                    section_path_class = '' 
            section_path_class

    Template.module_sections.helpers
        sections: ->
            Docs.find {
                type: 'section'
                module_id: FlowRouter.getParam('module_id')
                lightwork: $ne: true
            }, sort: number: 1


    Template.view_module.events
        'click .edit': ->
            module_id = FlowRouter.getParam('module_id')
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/#{course_id}/module/#{module_id}/edit"




    Template.view_section.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 1000
    
    
    # Template.module_lightwork.onRendered ->
    #     @autorun -> Meteor.subscribe 'module_lightwork', FlowRouter.getParam('module_id')

                
                
    Template.view_section.helpers
        section_doc: ->
            # console.log FlowRouter.getParam 'section_id'
            Docs.findOne FlowRouter.getParam('section_id'),
                lightwork: false


    Template.module_lightwork.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 1000
    

                
    Template.module_lightwork.helpers
        lightwork_doc: ->
            module_id = FlowRouter.getParam 'module_id'
            doc = Docs.findOne 
                lightwork: true
                type: 'section'
                module_id: module_id
                
            doc
            
            
if Meteor.isServer
    Meteor.publish 'module_lightwork', (module_id) ->
        Docs.find
            type: 'section'
            lightwork: true
            module_id: module_id