if Meteor.isClient
    # FlowRouter.route '/course/sol/module/:module_number/debrief', 
    #     name: 'reflective_questions'
    #     action: (params) ->
    #         BlazeLayout.render 'doc_module',
    #             module_content: 'reflective_questions'
        
    
    Template.reflective_questions.onCreated ->
        @autorun -> Meteor.subscribe 'reflective_questions', FlowRouter.getParam('module_number'), FlowRouter.getParam('section_number')
    
    # Template.answers.onCreated ->
        # @autorun => Meteor.subscribe 'answers', @data._id
    
    

    
    
    Template.reflective_questions.helpers
        reflective_questions: -> 
            mod_num = FlowRouter.getParam('module_number')
            sec_num = FlowRouter.getParam('section_number')
            Docs.find {
                tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"] }
                , { sort: number: 1} 
                
        # reflective_questions_tags: ->
        #     "sol","module #{FlowRouter.getParam('module_number')}","section #{FlowRouter.getParam('section_number')}","reflective question"
    
    
        has_answered_question: ->
            Docs.findOne
                tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()

    
    Template.reflective_answers.helpers
        all_reflective_answers: ->
            Docs.find
                parent_id: @_id
                tags: $in: ["answer"]
                published: true
                
        my_answer: ->
            Docs.findOne
                parent_id: @_id
                tags: $in: ["answer"]
                author_id: Meteor.userId()
                
        is_editing_my_answer: ->
            my_answer =             
                Docs.findOne
                    parent_id: @_id
                    tags: $in: ["answer"]
                    author_id: Meteor.userId()
            Session.equals 'editing_id', my_answer._id

    Template.reflective_answers.events
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            
    
    
    
    Template.reflective_questions.events
        'click #add_reflective_question': ->
            Docs.insert
                tags: ["sol","module #{FlowRouter.getParam('module_number')}","section #{FlowRouter.getParam('section_number')}","reflective question"]

        'click .add_reflective_answer': ->
            answer_tags = @tags
            answer_tags.push 'answer'
            # console.log 'answer tags', answer_tags
            new_id = Docs.insert
                tags: answer_tags
                parent_id: @_id
            Session.set 'editing_id', new_id

if Meteor.isServer
    publishComposite 'reflective_questions', (module_number, section_number)->
        {
            find: ->
                Docs.find 
                    tags: ["sol","module #{module_number}", "section #{section_number}","reflective question"]
            children: [
                { 
                    find: (question) ->
                        Docs.find
                            tags: $in: ["answer"]
                            parent_id: question._id
                    children: [
                        find: (answer) ->
                            Meteor.users.find
                                _id: answer.author_id
                        ]
                }
            ]
        }    
    
    # Meteor.publish 'answers', (parent_id)->
    #     # console.log parent_id
    #     Docs.find 
