if Meteor.isClient
    FlowRouter.route '/bookmarks', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'bookmarks'
    
    
    
    Template.bookmarks.onCreated ->
        @autorun => Meteor.subscribe('my_bookmarks', selected_tags.array())
        @autorun => Meteor.subscribe('bookmarked_tags', selected_tags.array())

        
    Template.bookmarks.onRendered ->
        selected_tags.clear()
        
    Template.bookmarks.helpers
        bookmarked_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3
                Tags.find { 
                    count: $lt: doc_count
                    }, limit:20
            else
                Tags.find({}, limit:20)
        cloud_tag_class: ->
            button_class = []
            switch
                when @index <= 5 then button_class.push ' '
                when @index <= 10 then button_class.push ' small'
                when @index <= 15 then button_class.push ' tiny'
                when @index <= 20 then button_class.push ' mini'
            return button_class
    
        selected_tags: -> selected_tags.array()

    
        bookmark_docs: -> 
            Docs.find
                bookmarked_ids: $in: [Meteor.userId()]

        bookmarks_count: ->
            Docs.find(bookmarked_ids: $in: [Meteor.userId()]).count()
            
            
    Template.bookmark.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

            
            
    Template.bookmarks.events
        'change #share_bookmarks': (e,t)->
            value = $('#share_bookmarks').is(":checked")
            Meteor.users.update Meteor.userId(), 
                $set:
                    "profile.share_bookmarks": value
    

        'click .select_tag': -> selected_tags.push @name
        'click .unselect_tag': -> selected_tags.remove @valueOf()
        'click #clear_tags': -> selected_tags.clear()

    
            
if Meteor.isServer
    publishComposite 'my_bookmarks', (selected_tags=[])->
        {
            find: ->
                match = {}
                
                if selected_tags.length > 0 then match.tags = $all: selected_tags
                match.bookmarked_ids = $in: [Meteor.userId()]

                Docs.find match
            children: [
                { find: (bookmark) ->
                    Meteor.users.find 
                        _id: bookmark.author_id
                    }
                ]    
        }
