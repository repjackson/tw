FlowRouter.route '/doc/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'doc_page'


if Meteor.isClient
    Template.doc_page.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.doc_page.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')
        
    
    Template.doc_page.events
        'click .edit': ->
            doc_id = FlowRouter.getParam('doc_id')
            FlowRouter.go "/doc/edit/#{doc_id}"

