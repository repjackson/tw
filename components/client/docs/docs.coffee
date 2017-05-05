FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'doc_page'


Template.docs.onCreated -> 
    @autorun -> Meteor.subscribe('docs', selected_tags.array(), type=null, 5)

Template.docs.helpers
    docs: -> 
        Docs.find { }, 
            sort:
                tag_count: 1
            limit: 10

    one_doc: -> 
        Docs.find().count() is 1

    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

    selected_tags: -> selected_tags.array()



Template.doc_page.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.doc_page.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    