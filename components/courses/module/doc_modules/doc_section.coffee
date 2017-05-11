if Meteor.isClient    
    FlowRouter.route '/course/sol/:module_number/:section_number', 
        name:'doc_section'
        action: (params) ->
            BlazeLayout.render 'doc_section'
    
    
    
    Template.doc_section.onCreated ->
        module_num = parseInt FlowRouter.getParam('module_number')
        section_num = parseInt FlowRouter.getParam('section_number')
        @autorun -> Meteor.subscribe 'module', module_num
        @autorun -> Meteor.subscribe 'section', module_num, section_num
        
    Template.doc_section.onRendered ->
        self = @
        
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    # $('#section_tabs .item').tab()
                    $('.ui.accordion').accordion()
                , 1000

    
    Template.doc_section.helpers
        module_number: -> FlowRouter.getParam('module_number')
    
        title_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},title"
    
        section_content_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},section #{FlowRouter.getParam('section_number')},content"
        section_transcript_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},section #{FlowRouter.getParam('section_number')},transcript"

    
        module: -> 
            Docs.findOne 
                tags: $in: ['module']
                number: parseInt FlowRouter.getParam('module_number')


        section: -> 
            Docs.findOne 
                tags: $in: ['section']
                number: parseInt FlowRouter.getParam('section_number')
            
    
    
    Template.doc_section.events
        'click .edit': ->
            module_number = FlowRouter.getParam('module_number')
            course_slug = FlowRouter.getParam('course_slug')
            FlowRouter.go "/course/#{course_slug}/module/#{@_id}/edit"
    
    
if Meteor.isServer
    Meteor.publish 'section', (module_number, section_number)->
        Docs.find
            tags: $in: ['section']
            module_number: module_number
            number: section_number