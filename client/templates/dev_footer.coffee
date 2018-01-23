# Template.dev_footer.onCreated ->
#     @autorun -> Meteor.subscribe('parent_doc', FlowRouter.getParam('doc_id'))

Template.dev_footer.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')


Template.dev_footer.events
    'click #create_child': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.insert
            parent_id: doc._id



