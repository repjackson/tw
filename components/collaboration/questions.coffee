FlowRouter.route '/questions', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'questions'

if Meteor.isClient
    Template.questions.onCreated -> 
        @autorun -> Meteor.subscribe('questions', FlowRouter.getParam('module_id'))
    
    
    Template.question.onCreated -> 
        # console.log @data?._id
        @autorun -> Meteor.subscribe('answers', @data?._id)

    
    Template.questions.helpers
        questions: -> 
            Docs.find
                type: 'question'
    
    
    
    
    Template.question.helpers
        answers: -> 
            Docs.find
                type: 'answer'
                question: @_id
    

    

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
                Docs.remove self._id


    Template.questions.events
        'click .remove_question': -> 
            self = @
            swal {
                title: 'Delete Question?'
                text: 'This will delete answers too.'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Docs.remove self._id

    
        
    
    
        'click #add_question': ->
            question = $('#new_question').val()
            # console.log question
            id = Docs.insert
                type: 'question'
                module: FlowRouter.getParam('module_id')
                text: question
            $('#new_question').val('')
    
    
    Template.question.events
        'click #add_answer': (e,t)->
            answer = $(e.currentTarget).closest('.input').find('#answer').val()
            id = Docs.insert
                type: 'answer'
                question: @_id
                text: answer
            $(e.currentTarget).closest('.input').find('#answer').val('')
    


if Meteor.isServer
    
    Meteor.publish 'questions', ()->
    
        self = @
        match = {}
        match.type = 'question'
        

        Docs.find match




    Meteor.publish 'answers', (id)->
    
        self = @
        match = {}

        match.question_id = id        
        match.type = 'answer'
        
        Docs.find match
    
