FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'


Template.docs.onCreated -> 
    @autorun -> Meteor.subscribe('docs', selected_theme_tags.array(), type=null, 5)

Template.docs.helpers
    docs: -> 
        Docs.find { }, 
            sort:
                tag_count: 1
            limit: 10

    one_doc: -> 
        Docs.find().count() is 1

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

    selected_theme_tags: -> selected_theme_tags.array()



Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    view_type_template: -> "view_#{@type}"
    