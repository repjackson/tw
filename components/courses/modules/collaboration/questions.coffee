FlowRouter.route '/questions', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'questions'


if Meteor.isClient
    Template.questions.onCreated -> 
        # @autorun -> Meteor.subscribe('questions', @data?._id)
    
    
    Template.question.onCreated -> 
        # console.log @data?._id
        @autorun -> Meteor.subscribe('answers', @data?._id)

    
    Template.questions.helpers
        questions: -> 
            Docs.find
                type: 'question'
                section_id: @_id
    
    
    Template.question.helpers
        answers: -> Docs.find type: 'answer'
    Template.question.events
        'click .remove_question': -> 
            self = @
            swal {
                title: 'Delete Question?'
                text: 'This will delete answers too. [not built]'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Docs.remove self._id

    


    Template.questions.events
        'click #add_question': (e,t)->
            question = $(e.currentTarget).closest('.input').find('#new_question').val()
            id = Docs.insert
                type: 'question'
                section_id: Template.parentData()._id
                text: question
            $(e.currentTarget).closest('.input').find('#new_question').val('')    
    

    Template.view_questions.onRendered ->
        Meteor.setTimeout ->
            $('#question_menu .item').tab()
            $('.ui.checkbox').checkbox('enable')
        , 2000
        
    Template.view_questions.helpers
        questions: -> 
            Docs.find
                type: 'question'
                section_id: @_id
                
        answers: -> 
            Docs.find 
                type: 'answer'
                question_id: @_id
        
        published_answers: -> 
            Docs.find 
                type: 'answer'
                question_id: @_id 
                published: true
                
        has_answered_question: ->
            Docs.findOne
                type: 'answer'
                question_id: @_id
                author_id: Meteor.userId()

        question_segment_class: -> 
            answer = Docs.findOne
                type: 'answer'
                question_id: @_id
                author_id: Meteor.userId()
            
            if answer?.published then 'teal' else ''

    Template.view_questions.events
        'click #add_answer': (e,t)->
            answer = $(e.currentTarget).closest('.input').find('#answer').val()
            id = Docs.insert
                type: 'answer'
                question_id: @_id
                published: false
                text: answer
            $(e.currentTarget).closest('.input').find('#answer').val('')
            Meteor.setTimeout =>
                $('#question_menu .item').tab()
            , 1000


        'keyup #answer': (e,t)->
            if e.which is 13
                answer = $(e.currentTarget).closest('.input').find('#answer').val()
                id = Docs.insert
                    type: 'answer'
                    question_id: @_id
                    published: false
                    text: answer
                $(e.currentTarget).closest('.input').find('#answer').val('')
                Meteor.setTimeout =>
                    $('#question_menu .item').tab()
                , 1000

        'click .remove_question': -> 
            self = @
            swal {
                title: 'Delete Question?'
                text: 'This will delete answers too. [not built]'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Docs.remove self._id

        'click .remove_answer': -> 
            self = @
            swal {
                title: 'Delete Answer?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Docs.remove self._id


        'click .toggle_published': (e,t)->
            published = $(e.currentTarget).closest('.ui.checkbox').checkbox('is checked')
            Docs.update @_id,
                $set:
                    published: published

if Meteor.isServer
    publishComposite 'questions', (section_id)->
        {
            find: ->
                Docs.find 
                    type: 'question'
                    section_id: section_id
            children: [
                { find: (question) ->
                    Docs.find
                        type: 'answer'
                        question_id: question._id
                }
            ]
        }