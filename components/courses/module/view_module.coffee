if Meteor.isClient    
    FlowRouter.route '/course/sol/module/:module_number', 
        name:'doc_module'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'sections'
    
    
    
    Template.doc_module.onCreated ->
        # @autorun -> Meteor.subscribe 'module_by_course_slug', course_slug=FlowRouter.getParam('course_slug'), module_number=parseInt FlowRouter.getParam('module_number')
        @autorun -> Meteor.subscribe 'module_progress', parseInt FlowRouter.getParam('module_number')
        @autorun -> Meteor.subscribe 'module', parseInt FlowRouter.getParam('module_number')
        
    Template.doc_module.onRendered ->
        self = @
        
        @autorun =>
            # console.log Session.get 'section_number'
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()            
                    module_number = Session.get('module_number')
    
                    module_progress_doc =  Docs.findOne(tags: $all: ["sol", "module progress","module #{module_number}"])
                    # console.log module_progress_doc
                    $('#module_percent_complete_bar').progress(
                        percent: module_progress_doc.module_progress_percent
                        autoSuccess: false
                        );
                , 1000

    
    Template.doc_module.helpers
        is_first_module: -> FlowRouter.getParam('module_number') is '1'
    
        module_number: -> FlowRouter.getParam('module_number')
    
        title_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},title"
    
        module: -> 
            Docs.findOne 
                tags: $in: ['module']
                number: parseInt FlowRouter.getParam('module_number')
            
        module_progress_doc: ->
            module_number = FlowRouter.getParam('module_number')
            Docs.findOne
                tags: ['sol', "module #{module_number}", 'module progress']
                author_id: Meteor.userId()

    
    Template.doc_module.events
        'click .edit': ->
            module_number = FlowRouter.getParam('module_number')
            course_slug = FlowRouter.getParam('course_slug')
            FlowRouter.go "/course/#{course_slug}/module/#{@_id}/edit"
    
        # 'click #calculate_module_progress': ->
        #     Meteor.call 'calculate_module_progress', parseInt(FlowRouter.getParam('module_number')), (err,res)->
        #         # console.log res
        #         $('#module_percent_complete_bar').progress('set percent', res);
        #         # console.log $('#module_percent_complete_bar').progress('get percent');

    
    
if Meteor.isServer
    Meteor.publish 'module', (module_number)->
        Docs.find
            tags: $in: ['module']
            number: module_number
            
    Meteor.publish 'module_progress', (module_number)->
        Docs.find
            tags: $all: ['sol', "module #{module_number}", "module progress"]
            # number: module_number
            
            
    Meteor.methods
        'calculate_module_progress': (module_number)->
            module_progress_doc = 
                Docs.findOne
                    tags: ['sol', "module #{module_number}", 'module progress']
                    author_id: Meteor.userId()

            # console.log module_progress_doc

            module_section_count = 
                Docs.find( 
                    tags: $in: ['section']
                    module_number: module_number
                ).count()
        
            # console.log module_section_count
            
            # for module_number in module_section_count
            #     console.log module_number
            
            module_progress = 0
            module_progress_increment = 100/module_section_count
            # console.log module_progress_increment
            for section_number in [1..module_section_count]
                section_progress_doc = 
                    Docs.findOne
                        tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
                        author_id: Meteor.userId()
                adding_amount = section_progress_doc.percent_complete*.01*module_progress_increment
                module_progress += adding_amount
                
            # console.log module_progress
            # Docs.update module_progress_doc._id, 
            #     module_progress_percent: module_progress
                
            update_result = Docs.update { 
                tags: ['sol', "module #{module_number}", 'module progress']
                author_id: Meteor.userId() 
            },
            { $set: module_progress_percent: module_progress },
            { upsert: true }
    
            # console.log module_progress
    
            return module_progress