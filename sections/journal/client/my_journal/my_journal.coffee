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
            tag_limit=10
            doc_limit=Session.get 'doc_limit'
            view_published=Session.get 'view_published'
            view_read=null
            view_bookmarked=false
            view_resonates=null
            view_complete=null
            view_images=null
            view_lightbank_type=null

            )
        
Template.my_journal.events
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal'
        Session.set 'editing', true
        FlowRouter.go("/view/#{new_journal_id}")    

Template.my_entry_view.onCreated -> 
    @autorun => Meteor.subscribe 'author', @data._id
    
    
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


    journal_card_class: -> if @published then 'blue' else ''
    
    published_count: -> Counts.get('unread_journal_count')



Template.my_entry_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    journal_segment_class: -> if @published then 'green raised' else ''


Template.my_entry_view.events





