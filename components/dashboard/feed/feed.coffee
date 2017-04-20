if Meteor.isClient
    Session.setDefault 'adding_id', null
    
    Template.feed.onCreated ->
        @autorun -> Meteor.subscribe('my_feed')
            

    Template.feed.events
        'click #add_post': ->
            new_id = Docs.insert type: 'feed_event'
            Session.set 'adding_id', new_id

    Template.feed_event.events
        'click .edit_post': -> Session.set 'editing_id', @_id
    
    Template.edit_feed_event.events
        'click #save_post': -> Session.set 'editing_id', null

    

    Template.feed.helpers
        adding_id: -> Session.get 'adding_id'
        my_feed: -> Docs.find type: 'feed_event'
            
    Template.add_post.events
        'click #save_post': -> Session.set 'adding_id', null
    Template.add_post.helpers
        adding_post: -> Docs.findOne Session.get 'adding_id'
    
            
if Meteor.isServer
    Meteor.publish 'my_feed', ->
        me = Meteor.users.findOne @userId
        Docs.find
            type: 'feed_event'