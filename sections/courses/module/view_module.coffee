if Meteor.isClient    
    # FlowRouter.route '/course/sol/module/:module_number', 
    #     name:'view_module'
    #     action: (params) ->
    #         BlazeLayout.render 'view_module',
    #             module_content: 'sections'
    
    # FlowRouter.route '/course/sol/module/:module_number', 
    #     name: 'view_module'
    #     triggersEnter: [ (context, redirect) ->
    #         # console.log context
    #         if context.params.module_number is "1"
    #             redirect "/course/sol/module/#{context.params.module_number}/sections"
    #         else 
    #             module_progress_doc =  Docs.findOne(tags: $all: ["sol", "module progress","module #{context.params.module_number}"])
    #             if module_progress_doc and module_progress_doc.module_debrief_complete
    #                 redirect "/course/sol/module/#{context.params.module_number}/sections"
    #             else
    #                 redirect "/course/sol/module/#{context.params.module_number}/debrief"
    #     ]

    
    Template.view_module.onCreated ->
        # @autorun -> Meteor.subscribe 'module_by_course_slug', course_slug=FlowRouter.getParam('course_slug'), module_number=parseInt FlowRouter.getParam('module_number')
        # @autorun -> Meteor.subscribe 'module_progress', parseInt FlowRouter.getParam('module_number')
        # @autorun -> Meteor.subscribe 'module', parseInt FlowRouter.getParam('module_number')
        # # @autorun -> Meteor.subscribe 'sol_modules'
        # @autorun -> Meteor.subscribe 'module_downloads', FlowRouter.getParam('module_number')

    Template.view_module.onRendered ->
        self = @
        if @subscriptionsReady()
            @autorun =>
            # console.log Session.get 'section_number'
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()  
                , 1000
                Meteor.setTimeout ->
                    $('.menu .item').tab()
                , 1000
                Meteor.setTimeout ->
                    module = Docs.findOne FlowRouter.getParam('doc_id')
                    # console.log 'module_number', module.number
                    module_progress_doc =  
                        Docs.findOne
                            type: 'module_progress'
                            parent_id: module._id
                            author_id: Meteor.userId()
                    # console.log 'module_progress_doc',module_progress_doc
                    # if module_progress_doc
                    $('#module_percent_complete_bar').progress(
                        percent: module_progress_doc.module_progress_percent
                        autoSuccess: false
                        )
                , 1000

    
    Template.view_module.helpers
        is_first_module: -> 
            module = Docs.findOne FlowRouter.getParam('doc_id')
            module.number is 1
    
        module: -> Docs.findOne FlowRouter.getParam('doc_id')
            
        download_count: ->
            module_doc = Docs.findOne FlowRouter.getParam('doc_id')

            Docs.find(
                parent_id: module_doc._id
                type: 'download'
                ).count()
            
        module_progress_doc: ->
            module = Docs.findOne FlowRouter.getParam('doc_id')
            module_progress_doc = Docs.findOne
                parent_id: module._id
                type: 'module_progress'
                author_id: Meteor.userId()
            # if module_progress_doc then alert 'hi' else alert 'no'
            # console.log module_progress_doc
            
        previous_module: ->
            module = Docs.findOne FlowRouter.getParam('doc_id')

            previous_module_number = module.number - 1
            Docs.findOne
                type: 'module'
                number: previous_module_number
            # console.log previous_module_number
                
        next_module: ->
            module = Docs.findOne FlowRouter.getParam('doc_id')
            next_module_number = module.number + 1
            next_module = Docs.findOne
                type: 'module'
                number: next_module_number
            # console.log next_module
            return next_module



        # module_sections_complete: ->
        #     module_number = parseInt FlowRouter.getParam('module_number')
        #     module_progress_doc = 
        #         Docs.findOne
        #             tags: $all: ['sol', "module #{module_number}", 'module progress']
        #             author_id: Meteor.userId()
        #     if module_progress_doc 
        #         module_progress_doc.module_progress_percent is 100
        #     else
        #         Meteor.call 'calculate_module_progress', module_number
        
        next_module_number: ->
            module = Docs.findOne FlowRouter.getParam('doc_id')
            module.number + 1
    
        next_module_exists: ->
            module = Docs.findOne FlowRouter.getParam('doc_id')
            next_module_number = module.number + 1

            next_module_doc = 
                Docs.findOne
                    type: 'module'
                    number: next_module_number
                    module_number: module_number
            if next_module_doc 
                console.log 'next module exists'
                return true 
            else 
                console.log 'next module DOESNT exists'
                return false
    
    
    
    Template.view_module.events
        'click #calculate_module_progress': ->
            Meteor.call 'calculate_module_progress', FlowRouter.getParam('doc_id'), (err,res)->
                # console.log res
                $('#module_percent_complete_bar').progress('set percent', res);
                # console.log $('#module_percent_complete_bar').progress('get percent');


    Template.user_module_progress_list.onRendered ->
        Meteor.setTimeout ->
            $('.progress').progress();
        , 1000

    Template.user_module_progress_list.onCreated ->
        @autorun -> Meteor.subscribe 'user_module_progress_docs', FlowRouter.getParam('doc_id')

    Template.user_module_progress_list.helpers
        user_progress_docs: ->
            module = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.find {
                type: 'module_progress'
                parent_id: module._id
            },
            sort: module_progress_percent: 1
    
if Meteor.isServer
    # publishComposite 'module', (module_id)->
    #     {
    #         find: ->
    #             Docs.find
    #                 type: 'module'
    #                 number: module_number
    #         children: [
    #             { 
    #                 find: (module_doc) ->
    #                     Docs.find
    #                         parent_id: module_doc._id
    #             }
    #         ]
            
    #     }
            
    # Meteor.publish 'module_progress', (module_id)->
    #     module_doc = 
    #         Docs.findOne
    #             type: 'module'
    #             number: module_number
    #     Docs.find
    #         type: 'module_progress'
    #         parent_id: module_doc._id
    #         author_id: Meteor.userId()
            
            
    # publishComposite 'user_module_progress_docs', (module_id)->
    #     {
    #         find: ->
    #             module_doc = 
    #                 Docs.findOne
    #                     type: 'module'
    #                     number: module_number
    #             Docs.find
    #                 type: 'module_progress'
    #                 parent_id: module_doc._id
    #         children: [
    #             { 
    #                 find: (progress_doc) ->
    #                     Meteor.users.find
    #                         _id: progress_doc.author_id
    #             }
    #         ]
    #     }    
        
            
    Meteor.methods
        'calculate_module_progress': (module_id)->
            module_doc = Docs.findOne module_id
            module_progress_doc=
                Docs.findOne
                    type: 'module_progress'
                    parent_id: module_doc._id
                    author_id: Meteor.userId()

            # console.log 'module_progress_doc',module_progress_doc


            module_section_count = 
                Docs.find( 
                    type: 'section'
                    parent_id: module_id
                ).count()
        
            # console.log 'module_section_count',module_section_count
            
            # for module_number in module_section_count
            #     console.log module_number
            
            module_progress = 0
            

            # 
            # debrief
            # 
                
            debrief_questions = 
                Docs.find(
                    type: 'debrief_question'
                    parent_id: module_doc._id
                ).fetch()
                
                
            debrief_question_count = 
                Docs.find(
                    type: 'debrief_question'
                    parent_id: module_doc._id
                ).count()
            # console.log 'debrief_question_count',debrief_question_count
            
            module_chunk_size = if debrief_question_count then 100/3 else 50

            
            debrief_answer_count = 0
            for debrief_question in debrief_questions
                console.log debrief_question
                debrief_answer = Docs.findOne
                    # tags: $in: ['answer']
                    parent_id: debrief_question._id
                    author_id: Meteor.userId()

                if debrief_answer then debrief_answer_count++
                
            # console.log 'debrief_answer_count',debrief_answer_count
            if debrief_answer_count is debrief_question_count
                module_debrief_complete = true
            else
                module_debrief_complete = false
            if debrief_question_count
                debrief_answered_fraction = debrief_answer_count/debrief_question_count
                debrief_adding_amount = debrief_answered_fraction * module_chunk_size
                module_progress += debrief_adding_amount
            
            # console.log 'module_progress', module_progress
            # console.log 'debrief_adding_amount', debrief_adding_amount
            
            

            # 
            # lightwork
            # 
                
            lightwork_questions = 
                Docs.find(
                    type: 'lightwork_question'
                    parent_id: module_doc._id
                ).fetch()
                
                
            lightwork_question_count = 
                Docs.find(
                    type: 'lightwork_question'
                    parent_id: module_doc._id
                ).count()
            # console.log lightwork_question_count
            
            lightwork_answer_count = 0
            for lightwork_question in lightwork_questions
                # console.log lightwork_question
                lightwork_answer = Docs.findOne
                    # tags: $in: ['answer']
                    parent_id: lightwork_question._id
                    author_id: Meteor.userId()
                if lightwork_answer then lightwork_answer_count++
                
            # console.log lightwork_answer_count
            if lightwork_answer_count is lightwork_question_count
                module_lightwork_complete = true
            else
                module_lightwork_complete = false
            
            lightwork_answered_fraction = lightwork_answer_count/lightwork_question_count
            # console.log 'lightwork_answered_fraction', lightwork_answered_fraction
            lightwork_adding_amount = lightwork_answered_fraction * module_chunk_size
            # console.log 'lightwork_adding_amount', lightwork_adding_amount
            
            module_progress += lightwork_adding_amount
            
            # console.log 'module_progress', module_progress
            # console.log 'lightwork_adding_amount', lightwork_adding_amount
            
            
            # 
            # sections
            # 
            
            module_section_progress_increment = module_chunk_size/module_section_count
            # console.log 'module_section_progress_increment', module_section_progress_increment
            section_complete_count = 0
            for section_number in [1..module_section_count]
                module_doc = 
                    Docs.findOne module_id
                section_doc = 
                    Docs.findOne
                        type: 'section'
                        parent_id: module_doc._id
                        number: section_number
                section_progress_doc = 
                    Docs.findOne
                        type: 'section_progress'
                        parent_id: section_doc._id
                        author_id: Meteor.userId()
                # console.log 'section_progress_doc', section_progress_doc
                if section_progress_doc then section_complete_count++
                if section_progress_doc
                    adding_amount = section_progress_doc.percent_complete*.01*module_section_progress_increment
                module_progress += adding_amount
                
                
                
            if section_complete_count is module_section_count
                module_sections_complete = true
            else
                module_sections_complete = false
                
                
            if module_sections_complete and module_lightwork_complete and module_debrief_complete
                # console.log 'sections,lightwork, and debrief complete'
                module_progress = 100
                
            # console.log 'module_sections_complete', module_sections_complete
            # Docs.update module_progress_doc._id, 
            #     module_progress_percent: module_progress
                
            update_result = Docs.update { 
                type: 'module_progress'
                parent_id: module_doc._id
                author_id: Meteor.userId() 
            },
            { $set: 
                module_progress_percent: module_progress
                module_section_count: module_section_count
                section_complete_count: section_complete_count
                module_sections_complete: module_sections_complete
                debrief_question_count: debrief_question_count
                debrief_answer_count: debrief_answer_count
                module_debrief_complete: module_debrief_complete
                lightwork_question_count: lightwork_question_count
                lightwork_answer_count: lightwork_answer_count
                module_lightwork_complete: module_lightwork_complete
                
                },
            { upsert: true }
    
            # console.log module_progress
    
            return module_progress