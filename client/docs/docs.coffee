FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    @autorun => Meteor.subscribe 'new_facet', 
        selected_theme_tags.array(), 
        FlowRouter.getParam('doc_id')
        type = null
        tag_limit = null
        doc_limit = 10
    
    
    
    
Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    view_type_template: -> "view_#{@type}"
    