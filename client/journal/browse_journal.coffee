FlowRouter.route '/journal/browse', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'browse_journal'

@selected_author_ids = new ReactiveArray []

Template.browse_journal.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='journal'
            author_id=null
            parent_id=null
            tag_limit=10
            doc_limit=10
            view_published=true
            view_read=null
            view_bookmarked=null
            view_resonates=null
            view_complete=null
            
            )
        
    # @autorun -> Meteor.subscribe 'unread_journal_count'
   
Template.browse_journal.events
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal'
        FlowRouter.go("/edit/#{new_journal_id}")    
   
   
        
Template.browse_entry_view.onCreated -> 
    @autorun => Meteor.subscribe 'author', @data._id
    
 
Template.browse_entry_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500


Template.browse_journal.helpers
    journal_entries: -> 
        match = {}
        match.type = 'journal'
        Docs.find match, 
            sort:
                timestamp: -1

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        
    journal_card_class: -> if @published then 'blue' else ''
    
    published_count: -> Counts.get('unread_journal_count')



Template.browse_entry_view.helpers
    # tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    journal_card_class: -> if @published then 'blue' else ''


# Template.browse_entry_view.events
#     'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())