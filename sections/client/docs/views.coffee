# Template.q_a.helpers
#     sessions: ->
#         Docs.find
#             parent_id: FlowRouter.getParam('doc_id')
#             type: 'session'
    
#     questions: ->
#         Docs.find
#             parent_id: FlowRouter.getParam('doc_id')
#             type: $ne: 'session'

Template.list.helpers
    children: ->
        if Session.get 'editing_id'
            Docs.find Session.get('editing_id')
        else
            Docs.find
                parent_id: FlowRouter.getParam('doc_id')
    
Template.cards.helpers
    children: ->
        if Session.get 'editing_id'
            Docs.find Session.get('editing_id')
        else
            Docs.find
                parent_id: FlowRouter.getParam('doc_id')
    

Template.sessions.helpers
    my_sessions: ->
        Docs.find
            type: 'session'
            author_id: Meteor.userId()
            parent_id: FlowRouter.getParam('doc_id')


Template.child_view.helpers
    child_view_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        console.log doc.child_fields
        doc.child_fields
    
    doc: ->
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        Template.parentData()
    
    has_title: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'title' in doc.child_fields
    
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'content' in doc.child_fields
        
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'tags' in doc.child_fields
        
Template.list_item.helpers
    child_view_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log doc.child_fields
        doc.child_fields
    
    doc: ->
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        Template.parentData()
    
    has_title: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'title' in doc.child_fields
    
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'content' in doc.child_fields
        
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'tags' in doc.child_fields
        
        