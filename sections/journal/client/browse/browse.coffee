FlowRouter.route '/journal/browse', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'browse_journal'

@selected_author_ids = new ReactiveArray []

Template.browse_journal.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('journal_docs', 
            selected_theme_tags.array(), 
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            false
            )
    @autorun -> Meteor.subscribe 'unread_journal_count'
        
            
            
            
            

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
        if selected_author_ids.array().length > 0 then match.author_id = $in: selected_author_ids.array()
        Docs.find match, 
            sort:
                timestamp: -1
            limit: 5

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

        
    journal_card_class: -> if @published then 'blue' else ''
    
    published_count: -> Counts.get('unread_journal_count')



Template.browse_entry_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    journal_card_class: -> if @published then 'blue' else ''

    read: -> Meteor.userId() in @read_by
    liked: -> Meteor.userId() in @liked_by
    
    read_count: -> @read_by.length    
    liked_count: -> @liked_by.length    


Template.browse_entry_view.events
    'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())

    'click .mark_read': (e,t)-> 
        $(e.currentTarget).closest('.journal_segment').transition('pulse')
        Docs.update @_id, $addToSet: read_by: Meteor.userId()
        
    'click .mark_unread': (e,t)-> 
        $(e.currentTarget).closest('.journal_segment').transition('pulse')
        Docs.update @_id, $pull: read_by: Meteor.userId()





