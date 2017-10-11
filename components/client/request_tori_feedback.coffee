Template.request_tori_feedback.onCreated ->
    # console.log Template.parentData()
    @autorun => Meteor.subscribe 'feedback_requested', Template.parentData()._id
            
            
Template.request_tori_feedback.helpers
    feedback_requested: ->
        parent_doc = Template.parentData()
        Docs.findOne
            type: 'transaction'
            parent_id: 'AHQnLo2eDES57mzJD'
            author_id: Meteor.userId()
            object_id: parent_doc._id


Template.request_tori_feedback.events
    'click #request_feedback': ->
        parent_doc = Template.parentData()
        if parent_doc
            Meteor.call 'create_transaction', 'AHQnLo2eDES57mzJD', parent_doc._id, ->
                Bert.alert "Tori's Feedback Requested.", 'success', 'growl-top-right'

        
    'click #cancel_request': ->
        parent_doc = Template.parentData()
        # console.log @
        request_transaction = Docs.findOne
            type: 'transaction'
            parent_id: 'AHQnLo2eDES57mzJD'
            author_id: Meteor.userId()
            object_id: parent_doc._id
        console.log request_transaction
        Docs.remove request_transaction._id, ->
            Bert.alert "Feedback Request Canceled.", 'info', 'growl-top-right'
        
       
       
