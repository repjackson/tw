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
                author_id=null
                parent_id=null
                tag_limit=null
                doc_limit=Session.get 'doc_limit'
                view_published=Session.get('view_published')
                view_read=Session.get('view_read')
                view_bookmarked=Session.get('view_bookmarked')
                view_resonates=Session.get('view_resonates')
                view_complete=Session.get 'view_complete'
                view_images = Session.get 'view_images'
                view_poems = Session.get 'view_poems'
                view_quotes = Session.get 'view_quotes'
                view_journal_prompts = Session.get 'view_journal_prompts'
                view_journal_passages = Session.get 'view_passages'

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
            Docs.find {type:'lightbank' }, 
                sort:
                    tag_count: 1
    
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        selected_theme_tags: -> selected_theme_tags.array()
        is_editing: -> Session.get 'editing_id'

        published_count: -> Counts.get('published_lightbank_count')
        unpublished_count: -> Counts.get('unpublished_lightbank_count')
    
    Template.lightbank.events
    
        'click #add_lightbank_doc': ->
            new_id = Docs.insert 
                type:'lightbank'
                tags: selected_theme_tags.array()
            Session.set 'view_unpublished', true
            FlowRouter.go "/edit/#{new_id}"
    
    
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
