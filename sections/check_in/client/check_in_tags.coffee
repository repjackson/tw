# import fullcalendar from 'fullcalendar'


FlowRouter.route '/checkins/tags', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'check_in_tags'


Template.check_in_tags.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='check_in_tag'
            author_id=Meteor.userId()
            parent_id=null
            tag_limit=10
            doc_limit=Session.get 'doc_limit'
            view_published=null
            view_read=null
            view_bookmarked=null
            view_resonates=null
            view_complete=null
            )


Template.check_in_tags.helpers
    check_in_tags: -> 
        if Session.get 'editing_id'
            Docs.find Session.get('editing_id')
        else
            Docs.find {type:'check_in_tag' }, 
                limit: 10
                sort: timestamp: -1

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'



Template.check_in_tags.events
    'click #add_check_in_tag': ->
        selected_theme_tags.clear()
        new_check_in_tag_id = Docs.insert type: 'check_in_tag'
        Session.set 'editing_id', new_check_in_tag_id

# Template.checkin_doc_view.helpers
#     tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

#     # check_in_tags: -> _.difference(@tags, 'checkin')
    
#     checkin_card_class: -> if @published then 'blue' else ''


# Template.checkin_doc_view.events
#     'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
