FlowRouter.route '/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit'

Template.edit.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


Template.edit.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    