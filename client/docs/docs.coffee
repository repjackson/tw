FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    view_type_template: -> "view_#{@type}"
    