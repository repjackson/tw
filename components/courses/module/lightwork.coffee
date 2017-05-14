if Meteor.isClient
    FlowRouter.route '/course/sol/module/:module_number/lightwork', 
        name: 'lightwork'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'lightwork'
    
    
    
    Template.lightwork.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 1000
    
    
                
    Template.lightwork.helpers
        lightwork_doc: ->
            console.log Template.parentData()
            module_number = parseInt FlowRouter.getParam 'module_number'
            doc = Docs.findOne 
                tags: $in: ["sol","module #{module_number}","lightwork"]
                module_number: module_number
                
            doc
            
        lightwork_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},lightwork"
            
        lightwork_transcript_tags: ->
            "sol,module #{FlowRouter.getParam('module_number')},lightwork,transcript"



    Template.lightwork_questions.onCreated ->
        @autorun -> Meteor.subscribe 'lightwork_questions', FlowRouter.getParam('module_number')
    
    # Template.lightwork_answers.onCreated ->
        # @autorun => Meteor.subscribe 'answers', @data._id
    
    Template.lightwork_questions.events
        'click #add_lightwork_question': ->
            Docs.insert
                tags: ["sol","module #{FlowRouter.getParam('module_number')}", "lightwork","question"]

        'click .add_lightwork_answer': ->
            answer_tags = @tags
            answer_tags.push 'answer'
            # console.log 'answer tags', answer_tags
            new_id = Docs.insert
                tags: answer_tags
                parent_id: @_id
            Session.set 'editing_id', new_id


    
    
    Template.lightwork_questions.helpers
        lightwork_questions: -> 
            if Roles.userIsInRole(Meteor.userId(), 'admin')
                Docs.find
                    tags: ["sol","module #{FlowRouter.getParam('module_number')}", "lightwork","question"]
            else
                Docs.find
                    tags: ["sol","module #{FlowRouter.getParam('module_number')}", "lightwork","question"]
                    published: true
                
                
        # lightwork_questions_tags: ->
        #     "sol,module #{FlowRouter.getParam('module_number')},lightwork,question"
    
    
        has_answered_question: ->
            Docs.findOne
                tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()
    
    
    Template.lightwork_answers.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500
                # console.log 'subs ready'

    
    
    Template.lightwork_answers.events
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            
    

    
    Template.lightwork_answers.helpers
        all_answers: ->
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

        
if Meteor.isServer
    publishComposite 'lightwork_questions', (module_number)->
        {
            find: ->
                Docs.find 
                    tags: ["sol","module #{module_number}", "lightwork","question"]
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
