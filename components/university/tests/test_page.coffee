Template.test_page.onCreated ->
    @autorun => Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')



Template.test_page.helpers
    test: ->
        Docs.findOne FlowRouter.getParam('doc_id')


Template.test_page.events
    'click .edit_test': ->
        FlowRouter.go "/test/#{@_id}/test"

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
        FlowRouter.go "/test/#{@_id}/test"