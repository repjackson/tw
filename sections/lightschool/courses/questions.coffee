if Meteor.isClient
    Template.questions.onCreated ->
        @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
        
    Template.question.onCreated ->
        @autorun => Meteor.subscribe 'child_docs', @data._id
    Template.answer.onCreated ->
        @autorun => Meteor.subscribe 'author', @data._id
        
    Template.questions.onRendered ->
        # Meteor.setTimeout ->
        #     $('.progress').progress()
        # , 2000
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 2000
                        
    # Template.question.onRendered ->
    #     # Meteor.setTimeout ->
    #     #     $('.progress').progress()
    #     # , 2000
    #     Meteor.setTimeout ->
    #         $('.ui.published_answers.accordion').accordion()
    #         $('.ui.private_answers.accordion').accordion()
    #     , 2000
                        
    Template.questions.helpers
        questions: ->
            Docs.find {parent_id: FlowRouter.getParam('doc_id')}, sort:number:1
            # Docs.find {}

        
    Template.question.helpers
        published_answers: ->
            Docs.find {parent_id: @_id, published:$in:[1,0]}

        
        private_answers: ->
            Docs.find {parent_id: @_id, published:-1}

        
        
        
    Template.my_answer.helpers
        answer: -> 
            Docs.findOne 
                author_id: Meteor.userId()
                parent_id:@_id
        
        
    Template.edit_section.events
        'click #delete_section': ->
            swal {
                title: 'Delete check in?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                section = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.remove section._id, ->
                    FlowRouter.go "/sections"        
                    
                    

    Template.answer.onCreated ->
        @autorun => Meteor.subscribe 'child_docs', @data._id
        
    Template.answer.events
        'click .reply': ->
            response_id = Docs.insert
                type:'response'
                content: ''
                parent_id: @_id
            FlowRouter.go("/edit/#{response_id}")    
        

        'click .thank': ->
            Meteor.call 'vote_up', @_id
                    
                    
