if Meteor.isClient    
    FlowRouter.route '/course/sol/module/:module_number/sol_section/:sol_section_number', 
        name:'view_sol_section'
        action: (params) ->
            BlazeLayout.reset()
            BlazeLayout.render 'view_sol_section'
    
    Template.user_sol_section_progress_list.onRendered ->
        Meteor.setTimeout ->
            $('.progress').progress();
        , 1000

    Template.user_sol_section_progress_list.onCreated ->
        # @autorun -> Meteor.subscribe 'user_sol_section_progress_docs', parseInt(FlowRouter.getParam('module_number')), parseInt(FlowRouter.getParam('sol_section_number'))

    Template.user_sol_section_progress_list.onRendered ->

    Template.user_sol_section_progress_list.helpers
        user_sol_section_progress_docs: ->
            # module_number = FlowRouter.getParam('module_number')
            # sol_section_number = FlowRouter.getParam('sol_section_number')
            # sol_section_doc = Docs.findOne
            #     type: 'sol_section'
            #     module_number: module_number
            #     number: sol_section_number
            # if sol_section_doc
                # sol_section_progress_docs=
            Docs.find 
                type: 'sol_section_progress'
                # parent_id: sol_section_doc._id}, 
                # sort: percent_complete: 1
    
    
    Template.view_sol_section.onCreated ->                
        # Session.set('module_number', parseInt(FlowRouter.getParam('module_number')))
        # Session.set('sol_section_number', parseInt(FlowRouter.getParam('sol_section_number')))
        # module_number = parseInt FlowRouter.getParam('module_number')
        # @autorun -> Meteor.subscribe 'module', parseInt(FlowRouter.getParam('module_number'))
        # @autorun -> Meteor.subscribe 'sol_sections', parseInt(FlowRouter.getParam('module_number'))
        # @autorun -> Meteor.subscribe 'sol_section_content', parseInt(FlowRouter.getParam('module_number')), parseInt(FlowRouter.getParam('sol_section_number'))
        # @autorun -> Meteor.subscribe 'sol_section_transcript', parseInt(FlowRouter.getParam('module_number')), parseInt(FlowRouter.getParam('sol_section_number'))
        # @autorun -> Meteor.subscribe 'sol_section', parseInt(FlowRouter.getParam('module_number')), parseInt(FlowRouter.getParam('sol_section_number'))
        # @autorun -> Meteor.subscribe 'sol_section_progress_doc', parseInt(FlowRouter.getParam('module_number')), parseInt(FlowRouter.getParam('sol_section_number'))
        # @autorun -> Meteor.subscribe 'reflective_questions', parseInt(FlowRouter.getParam('module_number')), parseInt(FlowRouter.getParam('sol_section_number'))
        # if @subscriptionsReady()
            # module_number = parseInt FlowRouter.getParam('module_number')
            # sol_section_number = parseInt FlowRouter.getParam('sol_section_number')
            # console.log module_number
            # console.log sol_section_number
            # sol_section_doc = Docs.findOne
            #     type: 'sol_section'
            #     # module_number: module_number
            #     number: sol_section_number
            # console.log sol_section_doc
            


    Template.view_sol_section.onRendered ->
        self = @
        
        @autorun =>
            # console.log Session.get 'sol_section_number'
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()            
                # module_number = FlowRouter.getParam('module_number')
                # sol_section_number = FlowRouter.getParam('sol_section_number')
                # sol_section_doc = Docs.findOne
                #     type: 'sol_section'
                #     module_number: module_number
                #     number: sol_section_number
                # if sol_section_doc
                sol_section_progress_doc=
                    Docs.find
                        type: 'sol_section_progress'
                        parent_id: FlowRouter.getParam('doc_id')
                        author_id: Meteor.userId()
                # console.log sol_section_progress_doc
                if sol_section_progress_doc
                    $('#sol_section_percent_complete_bar').progress(
                        percent: sol_section_progress_doc.percent_complete
                        autoSuccess: false
                        );
            , 1000

    
    Template.view_sol_section.helpers
        module_number: -> FlowRouter.getParam('module_number')
    
        # title_tags: -> "sol,module #{FlowRouter.getParam('module_number')},title"
    
        # sol_section_content_tags: ->
        #     module_number = FlowRouter.getParam('module_number')
        #     sol_section_number = FlowRouter.getParam('sol_section_number')
        #     "sol,module #{module_number},sol_section #{sol_section_number},content"
        # sol_section_transcript_tags: ->
        #     module_number = FlowRouter.getParam('module_number')
        #     sol_section_number = FlowRouter.getParam('sol_section_number')

        #     "sol,module #{FlowRouter.getParam('module_number')},sol_section #{FlowRouter.getParam('sol_section_number')},transcript"

        sol_section_progress_doc: ->
            module_number = parseInt FlowRouter.getParam('module_number')
            sol_section_number = parseInt FlowRouter.getParam('sol_section_number')
            sol_section_doc = Docs.findOne
                type: 'sol_section'
                module_number: module_number
                number: sol_section_number
            if sol_section_doc
                sol_section_progress_doc=
                    Docs.find
                        type: 'sol_section_progress'
                        parent_id: sol_section_doc._id
                        author_id: Meteor.userId()

        video_complete: ->
            sol_section_doc = Docs.findOne FlowRouter.getParam('doc_id') 

            sol_section_progress_doc=
                Docs.findOne
                    type: 'sol_section_progress'
                    parent_id: sol_section_doc._id
                    author_id: Meteor.userId()
            if sol_section_progress_doc
                sol_section_progress_doc.video_complete
        # reflective_question_docs: -> 
        #     module_number = FlowRouter.getParam('module_number')
        #     sol_section_number = FlowRouter.getParam('sol_section_number')
                
        #     sol_section_doc = Docs.findOne
        #         tags: $in: ['sol_section']
        #         number: sol_section_number
        #         module_number: module_number

        #     # if sol_section_doc
        #     Docs.find {
        #         # tags: $all: ['reflective', 'question']
        #         parent_id: sol_section_doc._id }
        #     , { sort: number: 1} 
                
                
                
        any_reflective_questions: ->
            sol_section_doc = Docs.findOne FlowRouter.getParam('doc_id') 
            if sol_section_doc
                Docs.find(
                    type: 'reflective_question'
                    parent_id: sol_section_doc._id 
                ).count()
                

        # reflective_question_answered: ->
        #     found_answer = Docs.findOne
        #         # tags: $in: ['answer']
        #         parent_id: @_id
        #         author_id: Meteor.userId()

        #     if found_answer
        #         console.log "has answered question #{@number}"
        #         return true
        #     else
        #         console.log "has NOT answered question #{@number}"
        #         return false
                
                
        # all_questions_answered: ->
        #     module_number = FlowRouter.getParam('module_number')
        #     sol_section_number = FlowRouter.getParam('sol_section_number')
        #     console.log question_count
        #     console.log answer_count
        #     question_count is answer_count    
                
        module: -> 
            sol_section = Docs.findOne FlowRouter.getParam('doc_id') 
            
            Docs.findOne 
                _id: sol_section.parent_id
                type: 'module'

    
        sol_section: -> Docs.findOne FlowRouter.getParam('doc_id') 
            
        previous_sol_section: ->
            sol_section_doc = Docs.findOne FlowRouter.getParam('doc_id') 
            previous_sol_section_number = sol_section_doc.number - 1

            Docs.findOne
                type: 'sol_section'
                number: previous_sol_section_number
                
        next_sol_section: ->
            sol_section_doc = Docs.findOne FlowRouter.getParam('doc_id') 
            next_sol_section_number = sol_section_doc.number + 1
            Docs.findOne
                type: 'sol_section'
                number: next_sol_section_number
                
        sol_section_complete: ->
            sol_section_progress_doc = 
                Docs.findOne
                    type: 'sol_section_progress'
                    parent_id: FlowRouter.getParam('doc_id') 
                    author_id: Meteor.userId()
            sol_section_progress_doc?.percent_complete is 100
    
        next_sol_section_number: ->  parseInt(FlowRouter.getParam('sol_section_number')) + 1
    
        next_sol_section_exists: ->
            sol_section_doc = Docs.findOne FlowRouter.getParam('doc_id') 

            next_sol_section_number = sol_section_doc.number + 1
            next_sol_section_doc = 
                Docs.findOne
                    type: 'sol_section'
                    number: next_sol_section_number
            if next_sol_section_doc then true else false
                    
                
        # is_editing: -> Session.get 'editing_id'    
    
    
    Template.view_sol_section.events
        'click .mark_video_complete': ->
            sol_section_id = FlowRouter.getParam('doc_id')
            sol_section_doc = Docs.findOne sol_section_id
            
            # console.log 'hi'
            Meteor.call 'toggle_video_complete', sol_section_id, true

            Meteor.call 'calculate_sol_section_progress', sol_section_id, (err,res)->
                # console.log res
                $('#sol_section_percent_complete_bar').progress('set percent', res);
                # console.log $('#sol_section_percent_complete_bar').progress('get percent');
            
            
            if sol_section_doc.content?.length
                swal {
                    title: "sol_section #{sol_section_doc.number}: #{sol_section_doc.title} Summary"
                    html: true
                    text: sol_section_doc.content
                    animation: true
                    showCancelButton: false
                    closeOnConfirm: true
                    confirmButtonText: 'OK'
                }


    
        'click .unmark_video_complete': ->
            sol_section_id = FlowRouter.getParam('doc_id')

            Meteor.call 'toggle_video_complete', sol_section_id, false
            
            Meteor.call 'calculate_sol_section_progress', sol_section_id, (err,res)->
                # console.log res
                $('#sol_section_percent_complete_bar').progress('set percent', res);
                # console.log $('#sol_section_percent_complete_bar').progress('get percent');

        'click #go_to_previous_sol_section': ->
            sol_section_id = FlowRouter.getParam('doc_id')
            sol_section_doc = Docs.findOne sol_section_id

            current_sol_section_number = parseInt FlowRouter.getParam('sol_section_number')
            previous_sol_section_number = sol_section_doc.number - 1
            $('#sol_section_percent_complete_bar').progress('reset');
            # Session.set 'sol_section_number', previous_sol_section_number
            FlowRouter.setParams({sol_section_number: previous_sol_section_number})
            Meteor.setTimeout ->
                sol_section_progress_doc =  Docs.findOne(tags: $in: ["sol_section progress"])
                # console.log sol_section_progress_doc
                $('#sol_section_percent_complete_bar').progress(
                    percent: sol_section_progress_doc.percent_complete
                    );
            , 1000

            
        'click .go_to_next_sol_section': ->
            current_sol_section_number = parseInt FlowRouter.getParam('sol_section_number')
            next_sol_section_number = current_sol_section_number + 1
            # Session.set 'sol_section_number', next_sol_section_number
            # $('#sol_section_percent_complete_bar').progress('reset');
            FlowRouter.setParams({sol_section_number: next_sol_section_number})
            Meteor.setTimeout ->
                sol_section_progress_doc =  Docs.findOne(tags: $in: ["sol_section progress"])
                # console.log sol_section_progress_doc
                $('#sol_section_percent_complete_bar').progress(
                    percent: sol_section_progress_doc.percent_complete
                    );
            , 1000

        'click #calculate_sol_section_progress': ->
            sol_section_id = FlowRouter.getParam('doc_id')
            sol_section_doc = Docs.findOne sol_section_id

            Meteor.call 'calculate_sol_section_progress', sol_section_id, (err,res)->
                # console.log res
                $('#sol_section_percent_complete_bar').progress('set percent', res);
                # console.log $('#sol_section_percent_complete_bar').progress('get percent');


        # 'click #mark_sol_section_complete': ->
        #     sol_section_id = FlowRouter.getParam('doc_id')
        #     sol_section_doc = Docs.findOne sol_section_id

        #     Meteor.call 'calculate_sol_section_progress', sol_section_id, (err,res)->
        #         # console.log res
        #         $('#sol_section_percent_complete_bar').progress('set percent', res);
        #         # console.log $('#sol_section_percent_complete_bar').progress('get percent');

    
    
        'click .popup_takeaway': ->
            sol_section_id = FlowRouter.getParam('doc_id')
            sol_section_doc = Docs.findOne sol_section_id

            swal {
                title: "sol_section #{sol_section_doc.number}: #{sol_section_doc.title} Summary"
                html: true
                text: sol_section_doc.content
                animation: true
                showCancelButton: false
                closeOnConfirm: true
                confirmButtonText: 'OK'
            }

    
if Meteor.isServer
    # Meteor.publish 'sol_section', (module_number, sol_section_number)->
        
    #     Docs.find
    #         type: 'sol_section'
    #         module_number: module_number
    #         number: sol_section_number
            
    # publishComposite 'sol_section', (module_number, sol_section_number)->
    #     {
    #         find: ->
    #             Docs.find
    #                 type: 'sol_section'
    #                 module_number: module_number
    #                 number: sol_section_number
    #         children: [
    #             { find: (sol_section) ->
    #                 Docs.find 
    #                     tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}","content"]
    #                 }
    #             ]    
    #     }
            
            
            
            
            
    # Meteor.publish 'sol_section_content', (module_number, sol_section_number)->
    #     Docs.find
    #         tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", "content"]
    #             # tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", "transcript"]
    
    # Meteor.publish 'sol_section_transcript', (module_number, sol_section_number)->
    #     Docs.find
    #         tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", "transcript"]
    
            
            
    # Meteor.publish 'sol_section_progress_doc', (sol_section_id)->
    #     sol_section_doc = Docs.findOne sol_section_id

    #     Docs.find
    #         type: 'sol_section_progress'
    #         parent_id: sol_section_doc._id
    #         author_id: Meteor.userId()


    publishComposite 'user_sol_section_progress_docs', (sol_section_id)->
        {
            find: ->
                Docs.find
                    type: 'sol_section_progress'
                    parent_id: sol_section_id
                    # tags: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", 'sol_section progress']
                    # author_id: Meteor.userId()

                # Docs.find
                #     tags: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", 'sol_section progress']
            children: [
                { 
                    find: (progress_doc) ->
                        Meteor.users.find
                            _id: progress_doc.author_id
                }
            ]
        }    


        
    Meteor.methods 
        'toggle_video_complete': (sol_section_id, boolean)->    
            sol_section_doc = Docs.findOne sol_section_id
            
            # console.log sol_section_id
            # console.log boolean
            Docs.update { 
                type: 'sol_section_progress'
                parent_id: sol_section_doc._id
                author_id: Meteor.userId() 
            },
            { $set: video_complete: boolean },
            { upsert: true }
            
            sol_section_progress_doc = Docs.findOne
                type: 'sol_section_progress'
                parent_id: sol_section_doc._id
                author_id: Meteor.userId()

            # console.log 'first found progress doc', sol_section_progress_doc
            # Meteor.call 'calculate_sol_section_progress', module_number, sol_section_number
    
        'calculate_sol_section_progress': (sol_section_id)->
            sol_section_doc = Docs.findOne sol_section_id

            reflective_questions = 
                Docs.find(
                    type: 'reflective_question'
                    parent_id: sol_section_doc._id
                ).fetch()
            
            reflective_question_count = 
                Docs.find(
                    type: 'reflective_question'
                    parent_id: sol_section_doc._id
                ).count()
            # console.log 'reflective_question_count', reflective_question_count
            
            reflective_answer_count = 0
            for reflective_question in reflective_questions
                # console.log reflective_question
                reflective_answer = Docs.findOne
                    # tags: $in: ['answer']
                    parent_id: reflective_question._id
                    author_id: Meteor.userId()

                if reflective_answer 
                    reflective_answer_count++
                    # console.log reflective_answer
                    
            console.log reflective_answer_count
                
            sol_section_progress_doc = 
                Docs.findOne
                    type: 'sol_section_progress'
                    parent_id: sol_section_doc._id
                    author_id: Meteor.userId()
                    
            if reflective_answer_count is reflective_question_count
                questions_complete = true
            else
                questions_complete = false
            if reflective_question_count is 0
                if sol_section_progress_doc?.video_complete
                    sol_section_progress = 100
                else
                    sol_section_progress = 50
            else    
                sol_section_answered_fraction = reflective_answer_count/reflective_question_count
                sol_section_progress = sol_section_answered_fraction*100
                    
            if not sol_section_progress_doc
                new_progress_doc_id = 
                    Docs.insert
                        percent_complete: 0
                        type: 'sol_section_progress'
                        parent_id: sol_section_doc._id
                        questions_complete: 0
                        reflective_question_count: reflective_question_count
                # console.log 'new progress doc id', new_progress_doc_id
                sol_section_progress_doc_id = new_progress_doc_id        
            else
                sol_section_progress_doc_id = sol_section_progress_doc._id        
            # console.log 'second found progress doc', sol_section_progress_doc
                            
            Docs.update sol_section_progress_doc_id,
                $set: 
                    reflective_question_count: reflective_question_count
                    reflective_answer_count: reflective_answer_count
                    questions_complete: questions_complete
                    percent_complete: sol_section_progress
                    
            return sol_section_progress
            
            # module_chunk_size = if debrief_question_count then 100/3 else 50

            
            # reflective_question_count = 
            #     Docs.find( 
            #         tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", 'reflective question']
            #         tag_count: 4
            #     ).count()
        
        
            # reflective_answer_count = 
            #     Docs.find( 
            #         tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", 'reflective question','answer']
            #         author_id: Meteor.userId()
            #     ).count()
                
            # console.log 'question count',reflective_question_count
            # console.log 'answer count',reflective_answer_count
            
            # found_answers = Docs.find( 
            #         tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", 'reflective question','answer']
            #         author_id: Meteor.userId()
            #     ).fetch()
            # console.log 'found_answers', found_answers

            # sol_section_progress_doc = 
            #     Docs.findOne
            #         tags: $all: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", 'sol_section progress']


            # if not sol_section_progress_doc
            #     new_progress_doc_id = 
            #         Docs.insert
            #             percent_complete: 0
            #             tags: ["sol", "module #{module_number}", "sol_section #{sol_section_number}", "sol_section progress"]
            #             questions_complete: 0
            #             reflective_question_count: reflective_question_count
            #     console.log 'new progress doc id', new_progress_doc_id
            
            # sol_section_progress_doc = 
            #     Docs.findOne
            #         tags: ['sol', "module #{module_number}", "sol_section #{sol_section_number}", 'sol_section progress']
            #         author_id: Meteor.userId()

            # if sol_section_progress_doc then console.log 'found' else console.log 'not'

            # if reflective_question_count is reflective_answer_count or reflective_question_count < reflective_answer_count
            #     questions_complete = true
            #     # console.log 'questions complete'
            # else
            #     questions_complete = false
            #     # console.log 'questions not complete'
                
            
            # console.log sol_section_progress_doc
    
                
            # if sol_section_progress_doc.video_complete
            #     if reflective_question_count is 0    
            #         Docs.update sol_section_progress_doc._id,$set:percent_complete: 100
            #         Meteor.call 'calculate_module_progress', module_number
            #         return 100
            #     else if questions_complete is false
            #         Docs.update sol_section_progress_doc._id,$set:percent_complete: 50
            #         Meteor.call 'calculate_module_progress', module_number
            #         return 50
            #     else if questions_complete is true
            #         Docs.update sol_section_progress_doc._id,$set:percent_complete: 100
            #         Meteor.call 'calculate_module_progress', module_number
            #         return 100
                    
            # else
            #     Docs.update sol_section_progress_doc._id,$set:video_complete: false
            #     if reflective_question_count is 0    
            #         Docs.update sol_section_progress_doc._id,$set:percent_complete: 0
            #         Meteor.call 'calculate_module_progress', module_number
            #         return 0
            #     else
            #         Meteor.call 'calculate_module_progress', module_number
            #         return 0
            
        # 'convert_content_and_transcript': (module_number, sol_section_number)->
        #     # console.log module_number
        #     # console.log sol_section_number
            
        #     sol_section_doc = Docs.findOne
        #         type: 'sol_section'
        #         number: sol_section_number
        #         module_number: module_number
        #     # console.log sol_section_doc


        #     content_doc = 
        #         Docs.findOne
        #             tags: $all: ["sol","module #{module_number}","sol_section #{sol_section_number}","content"]
        #     # console.log content_doc
            
        #     Docs.insert
        #         type:'sol_section_video'
        #         parent_id: sol_section_doc._id
        #         content: content_doc.content

        #     transcript_doc = 
        #         Docs.findOne
        #             tags: $all: ["sol","module #{module_number}","sol_section #{sol_section_number}","transcript"]
        #     # console.log transcript_doc
            
        #     Docs.insert
        #         type:'sol_section_transcript'
        #         parent_id: sol_section_doc._id
        #         content: transcript_doc.content
                