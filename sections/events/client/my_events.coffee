FlowRouter.route '/events/mine', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'my_events'

Template.my_events.onCreated -> 
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
            author_id=Meteor.userId()
            parent_id=null
            tag_limit=20
            doc_limit=Session.get 'doc_limit'
            view_published=null
            view_read=null
            view_bookmarked=null
            view_resonates=null
            view_complete=null
            )
        
Template.my_events.events
    'click #create_event': ->
        new_event_doc_id = Docs.insert type: 'event'
        Session.set 'editing', true
        
        FlowRouter.go("/view/#{new_event_doc_id}")

        
Template.my_event_view.onCreated -> 
    @autorun => Meteor.subscribe 'author', @data._id
 
    
Template.my_event_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500


Template.my_events.helpers
    my_events: -> 
        match = {}
        match.type = 'event'
        Docs.find match, 
            sort: timestamp: -1

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

    event_card_class: -> if @published then 'blue' else ''



Template.my_event_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    event_card_class: -> if @published then 'blue' else ''


Template.my_event_view.events
    'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())

