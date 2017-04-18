if Meteor.isClient
    Session.setDefault 'adding_id', null
    
    Template.comments.onCreated ->
        @autorun => Meteor.subscribe('comments', @data._id)
            

    Template.comments.events
        'click #add_comment': ->
            new_id = Docs.insert 
                type: 'comment'
                parent_id: @_id
            Session.set 'adding_id', new_id


    Template.comment.events
        'click .edit_comment': -> Session.set 'editing_id', @_id
        'click .reply': ->
            new_comment_id = Docs.insert
                type: 'comment'
                parent_id: @_id
            Session.set 'editing_id', new_comment_id
            
            Docs.update @_id,
                $addToSet: children: @_id

    
    Template.edit_comment.events
        'click #save_comment': -> Session.set 'editing_id', null

    Template.comment.helpers
        children_docs: -> 
            # console.log @
            Docs.find
                type: 'comment'
                _id: $in: @children
    

    Template.comments.helpers
        adding_id: -> Session.get 'adding_id'
        comments: -> Docs.find type: 'comment'
            
    Template.add_comment.events
        'click #save_comment': -> Session.set 'adding_id', null
    Template.add_comment.helpers
        adding_comment: -> Docs.findOne Session.get 'adding_id'
    
            
if Meteor.isServer
    Meteor.publish 'comments', (parent_id)->
        Docs.find
            type: 'comment'
            # parent_id: parent_id