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
    name:'view_section'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'view_section'


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
            }, sort: number: 1

    Template.module_sections.helpers
        sections: ->
            Docs.find {
                type: 'section'
                module_id: FlowRouter.getParam('module_id')
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
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')

                
                
    Template.view_section.helpers
        section_doc: ->
            # console.log FlowRouter.getParam 'section_id'
            Docs.findOne FlowRouter.getParam('section_id')

                
    # Template.module_sections.onRendered ->
    #     @autorun =>
    #         if @subscriptionsReady()
    #             Meteor.setTimeout ->
    #                 $('.ui.accordion').accordion()
    #             , 500
