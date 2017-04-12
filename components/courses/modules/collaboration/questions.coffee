@Questions = new Meteor.Collection 'questions'

Questions.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Questions.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

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
            Questions.find
                section_id: @_id
    
    
    Template.question.helpers
        answers: -> Answers.find {}
    


    Template.questions.events
        'click #add_question': (e,t)->
            question = $(e.currentTarget).closest('.input').find('#new_question').val()
            id = Questions.insert
                section_id: Template.parentData()._id
                text: question
            $(e.currentTarget).closest('.input').find('#new_question').val('')    
    

    Template.view_questions.onRendered ->
        Meteor.setTimeout ->
            $('#question_menu .item').tab()
        , 2000
        
    Template.view_questions.helpers
        questions: -> 
            Questions.find
                section_id: @_id
                
        answers: ->
            Answers.find
                question_id: @_id
                
                
        has_answered_question: ->
            Answers.findOne 
                question_id: @_id
                author_id: Meteor.userId()

    Template.view_questions.events
        'click #add_answer': (e,t)->
            answer = $(e.currentTarget).closest('.input').find('#answer').val()
            id = Answers.insert
                question_id: @_id
                text: answer
            $(e.currentTarget).closest('.input').find('#answer').val('')
            Meteor.setTimeout =>
                $('#question_menu .item').tab()
            , 1000


        'keyup #answer': (e,t)->
            if e.which is 13
                answer = $(e.currentTarget).closest('.input').find('#answer').val()
                id = Answers.insert
                    question_id: @_id
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
                Questions.remove self._id

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
                Answers.remove self._id




if Meteor.isServer
    Questions.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    publishComposite 'questions', (section_id)->
        {
            find: ->
                Questions.find section_id: section_id
            children: [
                { find: (question) ->
                    Answers.find
                        question_id: question._id
                }
            ]
        }