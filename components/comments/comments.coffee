if Meteor.isClient
    Session.setDefault 'adding_id', null
    
    Template.bookmarks.onCreated ->
        @autorun => Meteor.subscribe('bookmarks', @data._id)
    Template.comment.onCreated ->
        @editing_id = new ReactiveVar('')
        
    Template.bookmarks.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500

    Template.bookmarks.events
        'click #add_comment': ->
            new_id = Docs.insert 
                type: 'comment'
                parent_id: @_id
            Session.set 'adding_id', new_id
    
    
    Template.comment.events
        'click .edit_comment': (e,t)-> 
            # console.log t.editing_id
            t.editing_id.set @_id
    
        'click .reply': (e,t)->
            new_comment_id = Docs.insert
                type: 'comment'
                parent_id: @_id
            t.editing_id.set new_comment_id
            
            Docs.update @_id,
                $addToSet: children: new_comment_id
    
        'click #save_comment': (e,t)-> t.editing_id.set null
    
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
    
        editing_comment: ->
            editing_comment = Template.instance().editing_id.get()
            # console.log editing_comment
            editing_comment
        
        
    Template.bookmarks.helpers
        bookmarks: -> 
            Docs.find 
                type: 'comment'
                parent_id: @_id
            
if Meteor.isServer
    Meteor.publish 'bookmarks', (parent_id)->
        Docs.find
            type: 'comment'
            parent_id: parent_id            
            
