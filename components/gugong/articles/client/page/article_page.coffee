Template.article_page.onCreated ->
    self = @
    self.autorun ->
        self.subscribe 'doc', FlowRouter.getParam('doc_id')



Template.article_page.helpers
    article: ->
        Docs.findOne FlowRouter.getParam('doc_id')


Template.article_page.events
    'click .edit_article': ->
        FlowRouter.go "/article/edit/#{@_id}"
