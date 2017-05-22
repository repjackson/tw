if Meteor.isClient
    FlowRouter.route '/lightbank', action: (params) ->
        BlazeLayout.render 'layout',
            # cloud: 'cloud'
            main: 'lightbank'
    
    # Session.setDefault 'lightbank_view_mode', 'all'
    Template.lightbank.onCreated -> 
        @autorun -> 
            Meteor.subscribe('lightbank', 
                selected_tags.array(), 
                limit=10, 
                view_resonates=Session.get('view_resonates'), 
                view_bookmarked=Session.get('view_bookmarked'), 
                view_completed=Session.get('view_completed')
                view_published=Session.get('view_published')
                view_unpublished=Session.get('view_unpublished')
                )
        @autorun -> Meteor.subscribe 'unpublished_lightbank_count'
        @autorun -> Meteor.subscribe 'published_lightbank_count'
    
    
    Template.lightbank.helpers
        docs: -> 
            Docs.find {type:'lightbank' }, 
                sort:
                    tag_count: 1
                limit: 10
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
        selected_tags: -> selected_tags.array()
        all_item_class: -> 
            if Session.equals('view_resonates', false) and Session.equals('view_bookmarked', false) and Session.equals('view_completed', false)
                'active' 
            else ''
            
        published_count: -> Counts.get('published_lightbank_count')
        unpublished_count: -> Counts.get('unpublished_lightbank_count')
    
        resonates_item_class: -> if Session.equals 'view_resonates', true then 'active' else ''
        bookmarked_item_class: -> if Session.equals 'view_bookmarked', true then 'active' else ''
        completed_item_class: -> if Session.equals 'view_completed', true then 'active' else ''
        published_item_class: -> if Session.equals 'view_published', true then 'active' else ''
        unpublished_item_class: -> if Session.equals 'view_unpublished', true then 'active' else ''
    
    Template.lightbank.events
        'click #set_mode_to_all': -> 
            if Meteor.userId() 
                Session.set 'view_bookmarked', false
                Session.set 'view_resonates', false
                Session.set 'view_completed', false
            else FlowRouter.go '/sign-in'
    
        'click #toggle_resonates': -> 
            if Meteor.userId() 
                if Session.equals 'view_resonates', true
                    Session.set 'view_resonates', false
                else Session.set 'view_resonates', true
            else FlowRouter.go '/sign-in'
    
        'click #toggle_bookmarked': -> 
            if Meteor.userId() 
                if Session.equals 'view_bookmarked', true
                    Session.set 'view_bookmarked', false
                else Session.set 'view_bookmarked', true
            else FlowRouter.go '/sign-in'
    
        'click #toggle_completed': -> 
            if Meteor.userId() 
                if Session.equals 'view_completed', true 
                    Session.set 'view_completed', false
                else Session.set 'view_completed', true
            else FlowRouter.go '/sign-in'
    
        'click #toggle_published': -> 
            if Session.equals 'view_published', true 
                Session.set 'view_published', false
            else Session.set 'view_published', true
    
        'click #toggle_unpublished': -> 
            if Session.equals 'view_unpublished', true 
                Session.set 'view_unpublished', false
            else Session.set 'view_unpublished', true
    
    
    Template.lightbank_doc_view.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    
        when: -> moment(@timestamp).fromNow()
        
        lightbank_tags: -> _.difference(@tags, 'lightbank')
    
    Template.lightbank_doc_view.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())

if Meteor.isServer
    Meteor.publish 'lightbank', (selected_tags, limit, view_resonates, view_bookmarked, view_completed, view_published, view_unpublished)->
        self = @
        match = {}
        # match.tags = $all: selected_tags
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.type = 'lightbank'
        if view_resonates then match.favoriters = $in: [@userId]
        if view_bookmarked then match.bookmarked_ids = $in: [@userId]
        if view_completed then match.completed_ids = $in: [@userId]
        if view_published then match.published = true
        if view_unpublished then match.published = false
        # if lightbank_view_mode and lightbank_view_mode is 'mine'
        #     match.author_id
    
        if limit
            Docs.find match, 
                limit: limit
        else
            Docs.find match


    Meteor.publish 'unpublished_lightbank_count', ->
        Counts.publish this, 'unpublished_lightbank_count', Docs.find(type: 'lightbank', published:false)
        return undefined    # otherwise coffeescript returns a Counts.publish
    Meteor.publish 'published_lightbank_count', ->
        Counts.publish this, 'published_lightbank_count', Docs.find(type: 'lightbank', published:true)
        return undefined    # otherwise coffeescript returns a Counts.publish
