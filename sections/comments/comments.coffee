if Meteor.isClient
    Session.setDefault 'adding_id', null
    
    Template.comments.onCreated ->
        @autorun => Meteor.subscribe('comments', @data._id)
    Template.comment.onCreated ->
        @editing_id = new ReactiveVar('')
        
    Template.comments.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500

    Template.comments.events
        'click #add_comment': ->
            new_id = Docs.insert 
                type: 'comment'
                parent_id: @_id
            Session.set 'adding_id', new_id
    
    
    Template.comment.events
        'click .reply': (e,t)->
            new_comment_id = Docs.insert
                type: 'comment'
                parent_id: @_id
            t.editing_id.set new_comment_id
            
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
                
    
    Template.comment.helpers
        children_docs: -> 
            # console.log @
            Docs.find
                type: 'comment'
                _id: $in: @children
    
        
    Template.comments.helpers
        comments: -> 
            Docs.find 
                type: 'comment'
                parent_id: @_id
            
if Meteor.isServer
    Meteor.publish 'comments', (parent_id)->
        Docs.find
            type: 'comment'
            parent_id: parent_id            
            
