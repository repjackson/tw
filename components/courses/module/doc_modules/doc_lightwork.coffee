if Meteor.isClient
    FlowRouter.route '/course/sol/:module_number/lightwork', 
        name: 'doc_lightwork'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'doc_lightwork'
    
    
    
    Template.doc_lightwork.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 1000
    
    
                
    Template.doc_lightwork.helpers
        lightwork_doc: ->
            console.log Template.parentData()
            module_number = parseInt FlowRouter.getParam 'module_number'
            doc = Docs.findOne 
                tags: $in: ["sol","module #{module_number}","lightwork"]
                module_number: module_number
                
            doc
            
        lightwork_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},lightwork"
            
        lightwork_transcript_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},lightwork,transcript"
