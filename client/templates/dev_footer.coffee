# Template.dev_footer.onCreated ->
#     @autorun -> Meteor.subscribe('parent_doc', FlowRouter.getParam('doc_id'))

Template.dev_footer.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')


Template.dev_footer.events
    'click #create_child': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.insert
            parent_id: doc._id

    'click #create_parent': ->
        parent_doc_id = Docs.insert {}
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: parent_doc_id
        FlowRouter.go "/view/#{parent_doc_id}"


