if Meteor.isClient
    Template.test_page.onCreated ->
        @autorun => Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
        @autorun => Meteor.subscribe 'test_sessions', FlowRouter.getParam('doc_id')
    

    Template.test_page.helpers
        test: -> Docs.findOne FlowRouter.getParam('doc_id')
    
        my_sessions: ->
            Docs.find
                type: 'test_session'
                author_id: Meteor.userId()
                test_id: FlowRouter.getParam('doc_id')
    
    Template.test_page.events
        'click #new_session': ->
            new_session_id = 
                Docs.insert
                    type: 'test_session'
                    test_id: @_id
            FlowRouter.go("/test/#{@_id}/session/#{new_session_id}")
    
        
    Template.session_card.onRendered -> 
        Meteor.setTimeout ->
            $('.progress').progress()
        , 1000

    
    
    Template.edit_test.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.edit_test.helpers
        test: -> Docs.findOne FlowRouter.getParam('doc_id')
        
            
    Template.edit_test.events
        'click #save_test': ->
            # title = $('#title').val()
            publish_date = $('#publish_date').val()
            # description = $('#description').val()
            Docs.update FlowRouter.getParam('doc_id'),
                $set:
                    # title: title
                    publish_date: publish_date
                    # description: description
            FlowRouter.go "/test/#{@_id}/view"
            
if Meteor.isServer
    Meteor.publish 'test_sessions', (test_id)->
        Docs.find
            type: 'test_session'
            test_id: test_id
            author_id: @userId