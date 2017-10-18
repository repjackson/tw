FlowRouter.route '/events/browse', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'browse_events'

# @selected_author_ids = new ReactiveArray []

Template.browse_events.onCreated -> 
    self = @
    selected_theme_tags.clear()
    selected_location_tags.clear()
    selected_intention_tags.clear()

    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='event'
            author_id=null
            parent_id=null
            tag_limit=20
            doc_limit=Session.get 'doc_limit'
            view_published=true
            view_read=Session.get 'view_read'
            view_bookmarked=Session.get 'view_bookmarked'
            view_resonates=null
            view_complete=null
            )
            
        
Template.browse_events.events
    'click #create_event': ->
        new_event_doc_id = Docs.insert type: 'event'
        FlowRouter.go("/edit/#{new_event_doc_id}")





Template.browse_event_view.onCreated -> 
    @autorun => Meteor.subscribe 'author', @data._id
 
    
            

Template.browse_event_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500


Template.browse_events.helpers
    public_events: -> 
        match = {}
        match.type = 'event'
        # if selected_author_ids.array().length > 0 then match.author_id = $in: selected_author_ids.array()
        Docs.find match, 
            sort:
                timestamp: -1
            limit: 10

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

    # event_card_class: -> if @published then 'blue' else ''



Template.browse_event_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    event_card_class: -> if @published then 'blue' else ''


Template.browse_event_view.events
    'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())

