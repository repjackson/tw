if Meteor.isClient
    FlowRouter.route '/test/:doc_id/session/:session_id/', 
        name: 'edit_test_session'
        action: (params) ->
            BlazeLayout.render 'layout',
                sub_nav: 'member_nav'
                main: 'take_test'

    
    
    
    Template.test_session_view.onCreated -> 
        @autorun -> Meteor.subscribe('test_questions', FlowRouter.getParam('doc_id'))
        @autorun -> Meteor.subscribe('test_session', FlowRouter.getParam('session_id'))
    
    
    Template.test_session_view.helpers
        unpublished_questions: ->
            Docs.find
                type: 'test_question'
                test_id: FlowRouter.getParam('doc_id')
                published: false
                
        published_questions: ->
            Docs.find
                type: 'test_question'
                test_id: FlowRouter.getParam('doc_id')
                published: true
        
    
    
    Template.test_session_view.events
        'click #add_test_question': ->
            new_id = Docs.insert
                type: 'test_question'
                test_id: FlowRouter.getParam('doc_id')
            Session.set 'editing_id', new_id
                

if Meteor.isServer
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
