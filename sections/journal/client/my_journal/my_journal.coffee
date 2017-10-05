FlowRouter.route '/journal/mine', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'my_journal'

Template.my_journal.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='journal'
            author_id=Meteor.userId()
            parent_id=null
            manual_limit=null
            view_private=true
            view_published=false
            view_unread=false
            view_bookmarked=false
            )
        
            
Template.my_entry_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500


Template.my_journal.helpers
    journal_entries: -> 
        match = {}
        match.type = 'journal'
        Docs.find match, 
            sort:
                timestamp: -1
            limit: 10


    journal_card_class: -> if @published then 'blue' else ''
    
    published_count: -> Counts.get('unread_journal_count')



Template.my_entry_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    journal_segment_class: -> if @published then 'green raised' else ''


Template.my_entry_view.events





