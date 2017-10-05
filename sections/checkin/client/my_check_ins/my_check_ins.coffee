FlowRouter.route '/checkins/mine', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'my_check_ins'

# @selected_author_ids = new ReactiveArray []

Template.my_check_ins.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='checkin'
            author_id=null
            parent_id=null
            manual_limit=null
            view_private=true
            view_published=null
            view_unread=null
            view_bookmarked=null
            )
        
Template.my_check_in_view.onCreated -> 
    @autorun => Meteor.subscribe 'author', @data._id
 
    
            

Template.my_check_in_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500


Template.my_check_ins.helpers
    my_check_ins: -> 
        match = {}
        match.type = 'checkin'
        # if selected_author_ids.array().length > 0 then match.author_id = $in: selected_author_ids.array()
        Docs.find match, 
            sort:
                timestamp: -1
            limit: 10

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

    checkin_card_class: -> if @published then 'blue' else ''



Template.my_check_in_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    checkin_card_class: -> if @published then 'blue' else ''


Template.my_check_in_view.events
    'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())

