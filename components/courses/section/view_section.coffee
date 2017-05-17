if Meteor.isClient    
    FlowRouter.route '/course/sol/module/:module_number/section/:section_number', 
        name:'doc_section'
        action: (params) ->
            BlazeLayout.render 'doc_section'
    
    
    
    Template.doc_section.onCreated ->
        module_num = parseInt FlowRouter.getParam('module_number')
        section_num = parseInt FlowRouter.getParam('section_number')
        @autorun -> Meteor.subscribe 'module', module_num
        @autorun -> Meteor.subscribe 'sections', module_num
        @autorun -> Meteor.subscribe 'section_content', module_num, section_num
        @autorun -> Meteor.subscribe 'section', module_num, section_num
        @autorun -> Meteor.subscribe 'section_progress_doc', module_num, section_num
        @autorun -> Meteor.subscribe 'reflective_questions', FlowRouter.getParam('module_number'), FlowRouter.getParam('section_number')

    Template.doc_section.onRendered ->
        self = @
        
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                    $('#section_percent_complete_bar').progress();
                , 1000

    
    Template.doc_section.helpers
        module_number: -> FlowRouter.getParam('module_number')
    
        title_tags: -> "sol,module #{FlowRouter.getParam('module_number')},title"
    
        section_content_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},section #{FlowRouter.getParam('section_number')},content"
        section_transcript_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},section #{FlowRouter.getParam('section_number')},transcript"

        section_progress_doc: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')
            Docs.findOne
                tags: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                author_id: Meteor.userId()

        video_complete: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')

            section_progress_doc = Docs.findOne
                tags: $all: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                author_id: Meteor.userId()
            section_progress_doc?.video_complete
    
        reflective_question_docs: -> 
            mod_num = FlowRouter.getParam('module_number')
            sec_num = FlowRouter.getParam('section_number')
            Docs.find {
                tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"] }
                , { sort: number: 1} 
                
        any_reflective_questions: ->
            mod_num = FlowRouter.getParam('module_number')
            sec_num = FlowRouter.getParam('section_number')
            Docs.find({
                tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"] }).count()

        reflective_question_answered: ->
            found_answer = Docs.findOne
                tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()

            if found_answer
                # console.log "has answered question #{@number}"
                return true
            else
                # console.log "has NOT answered question #{@number}"
                return false
                
        module: -> 
            Docs.findOne 
                tags: $in: ['module']
                number: parseInt FlowRouter.getParam('module_number')

        section: -> 
            Docs.findOne 
                tags: $in: ['section']
                number: parseInt FlowRouter.getParam('section_number')
            
            
        previous_section: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_number = parseInt(FlowRouter.getParam('section_number'))
            previous_section_number = section_number - 1
            Docs.findOne
                tags: ['section']
                module_number: module_num
                number: previous_section_number
                
        next_section: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_number = parseInt(FlowRouter.getParam('section_number'))
            next_section_number = section_number + 1
            Docs.findOne
                tags: ['section']
                module_number: module_num
                number: next_section_number
                
        section_complete: ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')
            section_progress_doc = 
                Docs.findOne
                    tags: $all: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                    author_id: Meteor.userId()
            section_progress_doc?.percent_complete is 100
    
        next_section_number: -> 
            parseInt(FlowRouter.getParam('section_number')) + 1
    
    Template.doc_section.events
        'click .edit': ->
            module_number = FlowRouter.getParam('module_number')
            course_slug = FlowRouter.getParam('course_slug')
            FlowRouter.go "/course/#{course_slug}/module/#{@_id}/edit"
            
            
        'click .mark_video_complete': ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')

            section_progress_doc = Docs.findOne
                tags: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                author_id: Meteor.userId()
            Docs.update section_progress_doc?._id,
                $set: video_complete: true
            Meteor.call 'calculate_section_progress', module_num, section_num, ->
                $('#section_percent_complete_bar').progress('set percent', 100);
                # console.log $('#section_percent_complete_bar').progress('get percent');

    
        'click .unmark_video_complete': ->
            module_num = parseInt FlowRouter.getParam('module_number')
            section_num = parseInt FlowRouter.getParam('section_number')

            section_progress_doc = Docs.findOne
                tags: ['sol', "module #{module_num}", "section #{section_num}", 'section progress']
                author_id: Meteor.userId()
            Docs.update section_progress_doc._id,
                $set: video_complete: false
            Meteor.call 'calculate_section_progress', module_num, section_num, ->
                $('#section_percent_complete_bar').progress('set percent', 0);
                # console.log $('#section_percent_complete_bar').progress('get percent');

    
if Meteor.isServer
    Meteor.publish 'section', (module_number, section_number)->
        Docs.find
            tags: $in: ['section']
            module_number: module_number
            number: section_number
            
    Meteor.publish 'section_content', (module_number, section_number)->
        Docs.find
            tags: $in: ['sol', "module #{module_number}", "section #{section_number}"]
            
    Meteor.publish 'section_progress_doc', (module_number, section_number)->
        Docs.find
            tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
            author_id: @userId
        
        
    Meteor.methods 
        'calculate_section_progress': (module_number, section_number)->
            # console.log module_number
            # console.log section_number
            section_question_count = 
                Docs.find( tags: $all: ['sol', "module #{module_number}", "section #{section_number}", 'reflective question']).count()
        
            # console.log section_question_count

            section_progress_doc = 
                Docs.findOne
                    tags: $all: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
            
            if not section_progress_doc
                new_progress_doc_id = 
                    Docs.insert
                        percent_complete: 0
                        tags: ["sol", "module #{module_number}", "section #{section_number}", "section progress"]
                        questions_complete: 0
                        section_question_count: section_question_count
                console.log 'new progress doc id', new_progress_doc_id
            
            section_progress_doc = 
                Docs.findOne
                    tags: ['sol', "module #{module_number}", "section #{section_number}", 'section progress']
    
                
            if section_progress_doc?.video_complete
                if section_question_count is 0    
                    Docs.update section_progress_doc._id,
                        $set:percent_complete: 100
            else
                Docs.update section_progress_doc._id,
                    $set:video_complete: false
                if section_question_count is 0    
                    Docs.update section_progress_doc._id,
                        $set:percent_complete: 0
            
                

                
            # create section progress doc with modnum, secnum, fracttion_complete, %complete
            # if video_complete doc found, add 50% to progress_doc.%complete