if Meteor.isClient
    FlowRouter.route '/course/sol/:module_number/debrief', 
        name: 'doc_debrief'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'doc_debrief'
        
    
    Template.doc_debrief.onCreated ->
        @autorun -> Meteor.subscribe 'debrief_questions', FlowRouter.getParam('module_number')
    
    Template.answers.onCreated ->
        @autorun => Meteor.subscribe 'answers', @data._id
    
    
    Template.answers.helpers
        answers: ->
            Docs.find
                parent_id: @_id
                tags: $in: ["answer"]

    Template.answers.events
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            

    
    
    Template.doc_debrief.helpers
        debrief_questions: -> 
            Docs.find
                tags: ["sol","module #{FlowRouter.getParam('module_number')}", "debrief","question"]
                
        debrief_questions_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},debrief,question"
    
    
        has_answered_question: ->
            Docs.findOne
                tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()

    
    
    
    
    Template.doc_debrief.events
        'click #add_debrief_question': ->
            Docs.insert
                tags: ["sol","module #{FlowRouter.getParam('module_number')}", "debrief","question"]

        'click .add_debrief_answer': ->
            new_id = Docs.insert
                tags: ['debrief','answer']
                parent_id: @_id
            Session.set 'editing_id', new_id

if Meteor.isServer
    publishComposite 'debrief_questions', (module_number)->
        {
            find: ->
                Docs.find 
                    tags: ["sol","module #{module_number}", "debrief","question"]
            # children: [
            #     { find: (question) ->
            #         Docs.find
            #             type: 'answer'
            #             question_id: question._id
            #     }
            # ]
        }    
    
    Meteor.publish 'answers', (parent_id)->
        # console.log parent_id
        Docs.find 
            parent_id: parent_id
            tags: $in: ["answer"]
