Template.edit_article.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.edit_article.helpers
    article: -> Docs.findOne FlowRouter.getParam('doc_id')
    
        
Template.edit_article.events
    'click #save_article': ->
        # title = $('#title').val()
        publish_date = $('#publish_date').val()
        # description = $('#description').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set:
                # title: title
                publish_date: publish_date
                # description: description
        FlowRouter.go "/article/view/#{@_id}"