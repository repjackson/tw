if Meteor.isClient
    FlowRouter.route '/test/:doc_id/session/:session_id/', 
        name: 'edit_test_session'
        action: (params) ->
            BlazeLayout.render 'layout',
                sub_nav: 'member_nav'
                main: 'test_session'

    Template.test_session.onCreated -> 
        @autorun -> Meteor.subscribe('test_questions', FlowRouter.getParam('doc_id'))
        @autorun -> Meteor.subscribe('test_session', FlowRouter.getParam('session_id'))
    
    Template.results.onRendered -> 
        Meteor.setTimeout ->
            $('.progress').progress()
        , 1000

    Template.results.helpers
        test_session: -> 
            test_session = Docs.findOne type: 'test_session'
            # console.log test_session
            # test_session
        
        
    Template.test_session.helpers
        test_session: -> Docs.findOne type: 'test_session'
        test: -> Docs.findOne type: 'test'
        questions: -> Docs.find type: 'question'
        unanswered_questions: ->
            session_id = FlowRouter.getParam('session_id')
            rating_docs = Docs.find({type:'rating', session_id: session_id}, {fields:parent_id:1}).fetch()
            rating_parent_ids = []
            rating_parent_ids.push rating_doc.parent_id for rating_doc in rating_docs
            # console.log rating_parent_ids
            Docs.find
                type: 'test_question'
                test_id: FlowRouter.getParam('doc_id')
                _id: $nin: rating_parent_ids
                
        answered_questions: ->
            session_id = FlowRouter.getParam('session_id')
            rating_docs = Docs.find({type:'rating', session_id: session_id}, {fields:parent_id:1}).fetch()
            rating_parent_ids = []
            rating_parent_ids.push rating_doc.parent_id for rating_doc in rating_docs
            # console.log rating_parent_ids
            Docs.find
                type: 'test_question'
                test_id: FlowRouter.getParam('doc_id')
                _id: $in: rating_parent_ids
    
    
    Template.test_session.events
        'click #add_test_question': ->
            new_id = Docs.insert
                type: 'test_question'
                test_id: FlowRouter.getParam('doc_id')
            Session.set 'editing_id', new_id
                
        'click #calculate_answers': ->
            session_id = FlowRouter.getParam('session_id')
            Meteor.call 'calculate_life_assessment_answers', session_id
                
        'click #delete_session': ->
            session_id = FlowRouter.getParam('session_id')
            test_id = FlowRouter.getParam('doc_id')

            self = @
            swal {
                title: 'End Session?'
                text: 'This will clear all of the answers.'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'End Session'
                confirmButtonColor: '#da5347'
            }, ->
                Meteor.call 'delete_session', session_id, ->
                    swal("Deleted", "Your session has been deleted.", "success")
                    FlowRouter.go("/test/#{test_id}/view")


Meteor.methods
    'delete_session': (session_id)->
        remove_return = 
            Docs.remove
                type: 'rating'
                session_id: session_id
        Docs.remove session_id
        
    'calculate_life_assessment_answers': (session_id)->
        for tag in ['finance', 'business']        
            ratings = Docs.find({
                type: 'rating',
                session_id: session_id
                tags: $in: [tag]
                }).fetch()
            # console.log "ratings for #{tag}",ratings
            tag_score = 0    
            for rating in ratings
                tag_score += rating.rating
            # console.log tag_score
                
            Docs.update session_id,
                $addToSet:
                    results:    
                        category: tag
                        category_score: tag_score
                        category_percent: tag_score*10
                        
if Meteor.isServer
            # self = @
            # match = {}
            
            # match.type = 'rating'
            # match.session_id = session_id
            
            # life_assessment_results = Docs.aggregate [
            #     { $match: match }
            #     # { $project: tags: 1 }
            #     # { $unwind: '$tags' }
            #     # { $group: _id: '$tags', count: $sum: 1 }
            #     # { $sort: count: -1, _id: 1 }
            #     # { $limit: 100 }
            #     # { $project: _id: 0, name: '$_id', count: 1 }
            #     ]
            # Docs.update session_id,
            #     $set:
            #         results: life_assessment_results


    publishComposite 'test_session', (session_id)->
        {
            find: -> Docs.find session_id
            children: [
                { find: (session) ->
                    Docs.find
                        type: 'rating'
                        session_id: session._id
                # children: [
                #     {
                #         find: (test) ->
                #             Docs.find
                #                 type: 'question'
                #                 test_id: test._id
                #     }
                # ]    
                }
            ]
        }            
