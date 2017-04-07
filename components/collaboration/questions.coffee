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
        @autorun -> Meteor.subscribe('questions', @data?._id)
    
    
    Template.question.onCreated -> 
        # console.log @data?._id
        @autorun -> Meteor.subscribe('answers', @data?._id)

    
    Template.questions.helpers
        questions: -> Questions.find {}
    
    
    Template.question.helpers
        answers: -> Answers.find {}
    

    Template.question.events
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


    Template.questions.events
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

    
        
    
    
        'click #add_question': ->
            question = $('#new_question').val()
            id = Questions.insert
                section_id: Template.parentData()._id
                text: question
            $('#new_question').val('')
    
    
    Template.question.events
        'click #add_answer': (e,t)->
            answer = $(e.currentTarget).closest('.input').find('#answer').val()
            id = Answers.insert
                question: @_id
                text: answer
            $(e.currentTarget).closest('.input').find('#answer').val('')
    


if Meteor.isServer
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