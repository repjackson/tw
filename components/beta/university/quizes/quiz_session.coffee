if Meteor.isClient
    FlowRouter.route '/quiz/:quiz_slug/session/:session_id/', 
        name: 'edit_quiz_session'
        action: (params) ->
            BlazeLayout.render 'layout',
                # sub_nav: 'member_nav'
                main: 'quiz_session'

    Template.quiz_session.onCreated -> 
        @autorun => Meteor.subscribe 'quiz_by_slug', FlowRouter.getParam('quiz_slug')
        @autorun -> Meteor.subscribe('quiz_questions', selected_quiz_question_tags.array(), FlowRouter.getParam('quiz_slug'))
        @autorun -> Meteor.subscribe('quiz_session', FlowRouter.getParam('session_id'))
        @autorun => Meteor.subscribe('quiz_tags', selected_quiz_question_tags.array(), FlowRouter.getParam('quiz_slug'))

    Template.quiz_session.onRendered -> 
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 1000

    Template.results.onRendered -> 
        Meteor.setTimeout ->
            $('.progress').progress()
        , 1000

    Template.results.helpers
        quiz_session: -> 
            quiz_session = Docs.findOne type: 'quiz_session'
            # console.log quiz_session
            # quiz_session
        
        
    Template.quiz_session.helpers
        quiz_session: -> Docs.findOne type: 'quiz_session'
        quiz: -> Docs.findOne type: 'quiz'
        questions: -> Docs.find type: 'question'
        quiz_finished: -> Session.get 'quiz_finished'
        quiz_cloud_tags: -> Tags.find({})
        selected_quiz_question_tags: -> selected_quiz_question_tags.array()

        unanswered_questions: ->
            session_doc = Docs.findOne FlowRouter.getParam('session_id')
            if session_doc
                ratings = session_doc.ratings
                rating_question_ids = []
                rating_question_ids.push rating.question_id for rating in ratings
                # console.log rating_parent_ids
                Docs.find
                    type: 'quiz_question'
                    quiz_slug: FlowRouter.getParam('quiz_slug')
                    _id: $nin: rating_question_ids
                
        answered_questions: ->
            session_doc = Docs.findOne FlowRouter.getParam('session_id')
            if session_doc
                ratings = session_doc.ratings
                rating_question_ids = []
                rating_question_ids.push rating.question_id for rating in ratings
                # console.log rating_parent_ids
                Docs.find
                    type: 'quiz_question'
                    quiz_slug: FlowRouter.getParam('quiz_slug')
                    _id: $in: rating_question_ids
    
    
    Template.quiz_session.events
        'click #calculate_answers': ->
            Session.set 'quiz_finished', true
            session_id = FlowRouter.getParam('session_id')
            Meteor.call 'calculate_life_assessment_answers', session_id
                
        'click #delete_session': ->
            session_id = FlowRouter.getParam('session_id')
            quiz_slug = FlowRouter.getParam('quiz_slug')

            self = @
            swal {
                title: 'Cancel Session?'
                text: 'This will clear all of the answers.'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Nevermind'
                confirmButtonText: 'Cancel Session'
                confirmButtonColor: '#da5347'
            }, ->
                Meteor.call 'delete_session', session_id, ->
                    swal("Canceled", "Your session has been canceled.", "success")
                    FlowRouter.go("/quiz/#{quiz_slug}/view")

        'click .select_tag': -> selected_quiz_question_tags.push @name
        'click .unselect_tag': -> selected_quiz_question_tags.remove @valueOf()
        'click #clear_tags': -> selected_quiz_question_tags.clear()

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


    publishComposite 'quiz_session', (session_id)->
        {
            find: -> Docs.find session_id
            children: [
                { find: (session) ->
                    Docs.find
                        type: 'rating'
                        session_id: session._id
                # children: [
                #     {
                #         find: (quiz) ->
                #             Docs.find
                #                 type: 'question'
                #                 quiz_slug: quiz._id
                #     }
                # ]    
                }
            ]
        }            
