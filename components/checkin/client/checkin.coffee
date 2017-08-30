import fullcalendar from 'fullcalendar'


FlowRouter.route '/checkin', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'checkin'

FlowRouter.route '/checkin/calendar', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'checkin_calendar_view'


Template.checkin_calendar_view.onRendered ->
    $( '#checkin-calendar' ).fullcalendar();
    console.log fullcalendar

Template.checkin_calendar_view.helpers
    checkin_calendar_options: ->
        {
            defaultView: 'basicWeek'

        }





# Session.setDefault 'checkin_view_mode', 'all'
Template.checkin.onCreated -> 
    @autorun -> Meteor.subscribe('checkin', selected_tags.array(), limit=10, checkin_view_mode=Session.get('checkin_view_mode'))

Template.checkin.helpers
    docs: -> 
        Docs.find {type:'checkin' }, 
            sort:
                timestamp: -1
            limit: 10

    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

    selected_tags: -> selected_tags.array()

    all_item_class: -> if Session.equals 'checkin_view_mode', 'all' then 'active' else ''
    resonates_item_class: -> if Session.equals 'checkin_view_mode', 'resonates' then 'active' else ''

Template.checkin.events


Template.checkin_doc_view.helpers
    is_author: -> Meteor.userId() and @author_id is Meteor.userId()

    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

    when: -> moment(@timestamp).fromNow()
    
    checkin_tags: -> _.difference(@tags, 'checkin')

Template.checkin_doc_view.events
    'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
