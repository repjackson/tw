if Meteor.isClient
    FlowRouter.route '/bookmarks', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'bookmarks'
    
    Template.bookmark.onCreated ->
        @autorun => Meteor.subscribe 'author', @data._id

    
    Template.bookmarks.onCreated ->
        @autorun => 
            Meteor.subscribe('facet', 
                selected_theme_tags.array()
                selected_author_ids.array()
                selected_location_tags.array()
                selected_intention_tags.array()
                selected_timestamp_tags.array()
                type=null
                author_id=null
                parent_id=null
                tag_limit=10
                doc_limit=Session.get 'doc_limit'
                view_published=Session.get 'view_published'
                view_read=null
                view_bookmarked=true
                view_resonates=Session.get('view_resonates')
                view_complete=Session.get 'view_complete'
                view_images = Session.get 'view_images'
                view_lightbank_type = Session.get 'view_lightbank_type'
            )

        
    Template.bookmarks.onRendered ->
        selected_theme_tags.clear()
        
    Template.bookmarks.helpers
        bookmark_docs: -> 
            Docs.find
                bookmarked_ids: $in: [Meteor.userId()]

        bookmarks_count: ->
            Docs.find(bookmarked_ids: $in: [Meteor.userId()]).count()
            
            
    Template.bookmark.helpers
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

            
            
    Template.bookmarks.events
        'change #share_bookmarks': (e,t)->
            value = $('#share_bookmarks').is(":checked")
            Meteor.users.update Meteor.userId(), 
                $set:
                    "profile.share_bookmarks": value