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

Template.checkin.onCreated -> 
    @autorun -> Meteor.subscribe('checkin', selected_tags.array(), selected_author_ids.array(), limit=10, Session.get('view_mode'))

Template.checkin.helpers
    docs: -> 
        Docs.find {type:'checkin' }, 
            sort:
                timestamp: -1
            limit: 10

    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'



Template.checkin.events
    'keyup #quick_add': (e,t)->
        e.preventDefault
        tag = $('#quick_add').val().toLowerCase()
        if e.which is 13
            if tag.length > 0
                split_tags = tag.match(/\S+/g)
                $('#quick_add').val('')
                Meteor.call 'add_checkin', split_tags
                selected_tags.clear()
                for tag in split_tags
                    selected_tags.push tag

Template.checkin_doc_view.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

    # checkin_tags: -> _.difference(@tags, 'checkin')
    
    checkin_card_class: -> if @published then 'blue' else ''


Template.checkin_doc_view.events
    'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
