Meteor.methods
    mark_read: (doc_id)->
        Docs.update doc_id,
            $addToSet: read_by: Meteor.userId()
        
        
    mark_unread: (doc_id)->
        Docs.update doc_id,
            $pull: read_by: Meteor.userId()



Meteor.publish 'read_by', (doc_id)->
    doc = Docs.findOne doc_id
    if doc and doc.read_by
        Meteor.users.find
            _id: $in: doc.read_by
            
Meteor.publish 'feedback_requested', (doc_id)->
    Docs.find
        type: 'transaction'
        parent_id: 'AHQnLo2eDES57mzJD'
        author_id: Meteor.userId()
        object_id: doc_id
            
Meteor.publish 'person_tags', (username)->
    user = Meteor.users.findOne username: username
    Docs.find
        type: 'person_tags'
        parent_user_id: user._id
        
Meteor.publish 'document_tags', (doc_id)->
    Docs.find
        type: 'tag_rating'
        parent_id: doc_id        