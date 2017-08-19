if Meteor.isClient
    FlowRouter.route '/bookmarks', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'bookmarks'
    
    
    
    Template.bookmarks.onCreated ->
        @autorun => Meteor.subscribe('my_bookmarks')

        
    Template.bookmarks.onRendered ->

    Template.bookmarks.helpers
        bookmark_docs: -> 
            Docs.find
                bookmarked_ids: $in: [Meteor.userId()]

        bookmarks_count: ->
            Docs.find(bookmarked_ids: $in: [Meteor.userId()]).count()
            
            
if Meteor.isServer
    publishComposite 'my_bookmarks', ->
        {
            find: ->
                Docs.find
                    bookmarked_ids: $in: [Meteor.userId()]
            children: [
                { find: (bookmark) ->
                    Meteor.users.find 
                        _id: bookmark.author_id
                    }
                ]    
        }
