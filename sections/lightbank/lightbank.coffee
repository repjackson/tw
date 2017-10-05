if Meteor.isClient
    FlowRouter.route '/lightbank', action: (params) ->
        BlazeLayout.render 'layout',
            # cloud: 'cloud'
            main: 'lightbank'
    
    
    # Session.setDefault 'lightbank_view_mode', 'all'
    Template.lightbank.onCreated -> 
        @autorun => 
            Meteor.subscribe('facet', 
                selected_theme_tags.array()
                selected_author_ids.array()
                selected_location_tags.array()
                selected_intention_tags.array()
                selected_timestamp_tags.array()
                type='lightbank'
                author_id=Meteor.userId()
                parent_id=null
                manual_limit=null
                view_private=false
                view_published=Session.get('view_published')
                view_unread=false
                view_bookmarked=Session.get('view_bookmarked')
                view_resonates=Session.get('view_resonates')
                )

        @autorun -> Meteor.subscribe 'unpublished_lightbank_count'
        @autorun -> Meteor.subscribe 'published_lightbank_count'
    
    
    Template.lightbank.onRendered -> selected_theme_tags.clear()
    
    Template.lightbank_doc_view.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500

    
    Template.lightbank.helpers
        docs: -> 
            if Session.get 'view_unpublished'
                Docs.find
                    type: 'lightbank'
                    published: false
            else
                Docs.find {type:'lightbank' }, 
                    sort:
                        tag_count: 1
                    limit: 5
    
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        selected_theme_tags: -> selected_theme_tags.array()
        is_editing: -> Session.get 'editing_id'

        all_item_class: -> 
            if Session.equals('view_resonates', false) and Session.equals('view_bookmarked', false) and Session.equals('view_completed', false)
                'active' 
            else ''
            
        published_count: -> Counts.get('published_lightbank_count')
        unpublished_count: -> Counts.get('unpublished_lightbank_count')
    
        resonates_item_class: -> 
            if not Meteor.userId() then 'disabled'
            else if Session.equals 'view_resonates', true then 'active' else ''
        bookmarked_item_class: -> 
            if not Meteor.userId() then 'disabled'
            else if Session.equals 'view_bookmarked', true then 'active' else ''
        completed_item_class: -> 
            if not Meteor.userId() then 'disabled'
            else if Session.equals 'view_completed', true then 'active' else ''
        published_item_class: -> 
            if not Meteor.userId() then 'disabled'
            else if Session.equals 'view_published', true then 'active' else ''
        unpublished_item_class: -> 
            if not Meteor.userId() then 'disabled'
            else if Session.equals 'view_unpublished', true then 'active' else ''
    
    Template.lightbank.events
    
        'click #add_lightbank_doc': ->
            new_id = Docs.insert 
                type:'lightbank'
                tags: selected_theme_tags.array()
            Session.set 'view_unpublished', true
            FlowRouter.go "/edit/#{new_id}"
    
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
    
    
    Template.edit_lightbank.events
        'click #delete_doc': ->
            if confirm 'Delete this doc?'
                Docs.remove @_id
                FlowRouter.go '/lightbank'
    
    
    
    Template.lightbank_doc_view.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        when: -> moment(@timestamp).fromNow()
        light_bank_content_class: -> if 'quote' in @tags then 'large150' else ''
    
    
    Template.lightbank_doc_view.events
        'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())

if Meteor.isServer
    Meteor.publish 'unpublished_lightbank_count', ->
        Counts.publish this, 'unpublished_lightbank_count', Docs.find(type: 'lightbank', published:false)
        return undefined    # otherwise coffeescript returns a Counts.publish
    Meteor.publish 'published_lightbank_count', ->
        Counts.publish this, 'published_lightbank_count', Docs.find(type: 'lightbank', published:true)
        return undefined    # otherwise coffeescript returns a Counts.publish
    Meteor.publish 'unread_lightbank_count', ->
        Counts.publish this, 'unread_lightbank_count', 
            Docs.find(
                type: 'lightbank' 
                published:true
                read_by: $nin: [Meteor.userId()]
            )
        return undefined    # otherwise coffeescript returns a Counts.publish
