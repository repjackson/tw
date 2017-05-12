if Meteor.isClient    
    FlowRouter.route '/course/sol/module/:module_number', 
        name:'doc_module'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'module_sections'
    
    
    
    Template.doc_module.onCreated ->
        # @autorun -> Meteor.subscribe 'module_by_course_slug', course_slug=FlowRouter.getParam('course_slug'), module_number=parseInt FlowRouter.getParam('module_number')
        # @autorun -> Meteor.subscribe 'course_by_slug', FlowRouter.getParam('course_slug')
        @autorun -> Meteor.subscribe 'module', parseInt FlowRouter.getParam('module_number')
        
    
    
    Template.doc_module.helpers
        is_first_module: ->
            parseInt FlowRouter.getParam('module_number') is 1
    
        module_number: -> FlowRouter.getParam('module_number')
    
        title_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},title"
    
        module: -> 
            Docs.findOne 
                tags: $in: ['module']
                number: parseInt FlowRouter.getParam('module_number')
                # parent_course_slug: FlowRouter.getParam('course_slug')
        # course: -> 
        #     Courses.findOne 
        #         slug:FlowRouter.getParam('course_slug')
            
    
    
    Template.doc_module.events
        'click .edit': ->
            module_number = FlowRouter.getParam('module_number')
            course_slug = FlowRouter.getParam('course_slug')
            FlowRouter.go "/course/#{course_slug}/module/#{@_id}/edit"
    
    
    # Template.view_section.onCreated ->
    #     @autorun -> Meteor.subscribe 'section', module_number=parseInt FlowRouter.getParam('module_number'), section_number=parseInt FlowRouter.getParam('section_number')
    
    
    
    # Template.view_section.onRendered ->
    #     @autorun =>
    #         if @subscriptionsReady()
    #             Meteor.setTimeout ->
    #                 $('.ui.accordion').accordion()
    #             , 1000
    
    
    # # Template.module_lightwork.onRendered ->
    # #     @autorun -> Meteor.subscribe 'module_lightwork', FlowRouter.getParam('module_number')
    
                
                
    # Template.view_section.helpers
    #     section_doc: ->
    #         Docs.findOne 
    #             number: parseInt FlowRouter.getParam('section_number')
    #             # module_number: parseInt FlowRouter.getParam('module_number')
    #             type: 'section'
    #             # lightwork: false
    
    
if Meteor.isServer
    Meteor.publish 'module', (module_number)->
        Docs.find
            tags: $in: ['module']
            number: module_number