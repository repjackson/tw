if Meteor.isClient
    Template.questions.onCreated ->
        @autorun => Meteor.subscribe 'questions', @data.type, @data.parent_id
        # console.log @data
    
    Template.question.onCreated ->
        @autorun => Meteor.subscribe 'question', @data._id
        # console.log @data
    
    Template.questions.helpers
        question_docs: -> 
            parent_id = Template.currentData().parent_id
            type = Template.currentData().type
            Docs.find {
                type: type
                parent_id: parent_id
                }
                # tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"] }
                , { sort: number: 1} 
                
        # questions_tags: ->
        #     "sol","module #{FlowRouter.getParam('module_number')}","section #{FlowRouter.getParam('section_number')}","reflective question"
    
        any_questions: ->
            Docs.find({
                # tags: ["question"]
                parent_id: Template.currentData().parent_id
                }).count()

        questions_title: -> if Template.currentData().title then Template.currentData().title else 'Questions'
            
        has_answered_previous: ->
            # console.log @number
            # console.log @body
            if Roles.userIsInRole Meteor.userId(), 'admin' then true
            else
                # mod_num = FlowRouter.getParam('module_number')
                # sec_num = FlowRouter.getParam('section_number')
                if @number is 1 then true
                else
                    previous_number = @number - 1
                    
                    previous_question = Docs.findOne
                        # tags: ["sol","module #{mod_num}","section #{sec_num}","reflective question"]
                        parent_id: Template.currentData().parent_id
                        number: previous_number
                    
                    if previous_question
                        previous_question_answer = 
                            Docs.findOne
                                tags: $in: ['answer']
                                parent_id: previous_question._id
                                author_id: Meteor.userId()
                        if previous_question_answer 
                            if Session.get('editing_id') isnt previous_question_answer._id
                                # console.log 'has answered question', previous_question.number
                                return true
                        else
                            # console.log 'has NOT answered question', previous_question.number
                            return false    
                        
                            
    Template.answers.helpers
        question_segment_class: ->
            found_answer = Docs.findOne
                # tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()
            if found_answer then 'raised green' else ''
                
    
    Template.answers.helpers
        has_answered_question: ->
            # console.log @_id
            found_answer = Docs.findOne
                # tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()
            # if @number is 3
            #     if found_answer
            #         console.log "has answered question #{@number}"
            #         console.log found_answer
            #     else
            #         console.log "has NOT answered question #{@number}"
            return found_answer

        all_answers: ->
            Docs.find
                parent_id: @_id
                # tags: $in: ["answer"]
                published: true
                
        all_private_answers: ->        
            Docs.find
                parent_id: @_id
                # tags: $in: ["answer"]
                published: false
                
                
        my_answer: ->
            Docs.findOne
                parent_id: @_id
                # tags: $in: ["answer"]
                author_id: Meteor.userId()
                
        is_editing_my_answer: ->
            my_answer =             
                Docs.findOne
                    parent_id: @_id
                    # tags: $in: ["answer"]
                    author_id: Meteor.userId()
            Session.equals 'editing_id', my_answer._id

    Template.answers.events
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            
    Template.answers.onRendered ->
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 1000
                # console.log 'subs ready'

    

    
    
    Template.questions.events
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            
    
        'click #add_question': ->
            question_tags = Template.parentData().tags
            question_tags.push 'question'
            question_tags.push "module #{Template.parentData().number}"
            console.log Template.currentData()
            Docs.insert
                parent_id: Template.currentData().parent_id
                tags: question_tags
                type: Template.currentData().type

        'click .add_answer': ->
            answer_tags = @tags
            answer_tags.push 'answer'
            answer_tags.push "question #{@number}"
            # console.log 'answer tags', answer_tags
            # console.log @_id
            # console.log @number
            new_id = Docs.insert
                type: 'answer'
                tags: answer_tags
                parent_id: @_id
                question_number: @number
            # console.log Docs.findOne new_id
            Session.set 'editing_id', new_id

if Meteor.isServer
    # publishComposite 'questions', (module_number, section_number)->
    publishComposite 'questions', (type, parent_id)->
        {
            find: ->
                Docs.find 
                    type: type
                    parent_id: parent_id
                    # tags: ["sol","module #{module_number}", "section #{section_number}","reflective question"]
            children: [
                { 
                    find: (question) ->
                        # console.log 'question:', question
                        cursor = Docs.find
                            # tags: $in: ["answer"]
                            parent_id: question._id
                        # console.log cursor.fetch()
                        return cursor
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
