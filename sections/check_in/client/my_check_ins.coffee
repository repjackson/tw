FlowRouter.route '/checkins/mine', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'my_check_ins'

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
        
Template.my_check_ins.events
    'click #create_checkin': ->
        new_checkin_doc_id = Docs.insert type: 'checkin'
        FlowRouter.go("/edit/#{new_checkin_doc_id}")

        
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
        Docs.find match, 
            sort: timestamp: -1

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

    checkin_card_class: -> if @published then 'blue' else ''



Template.my_check_in_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    checkin_card_class: -> if @published then 'blue' else ''


Template.my_check_in_view.events
    'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())

