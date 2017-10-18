# import fullcalendar from 'fullcalendar'


FlowRouter.route '/events', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'events'

# FlowRouter.route '/event/calendar', action: (params) ->
#     BlazeLayout.render 'layout',
#         # cloud: 'cloud'
#         main: 'event_calendar_view'





# Template.events_calendar_view.onRendered ->
#     $( '#event-calendar' ).fullcalendar();
#     console.log fullcalendar

# Template.event_calendar_view.helpers
#     event_calendar_options: ->
#         {
#             defaultView: 'basicWeek'

#         }



Template.events.helpers
    # docs: -> 
    #     Docs.find {type:'event' }, 
    #         sort:
    #             timestamp: -1
    #         limit: 10

    # tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'



Template.events.events
    'click #create_event': ->
        new_event_doc_id = Docs.insert 
            tags: []
            type: 'event'
        FlowRouter.go("/edit/#{new_event_doc_id}")

    'keyup #quick_add': (e,t)->
        e.preventDefault
        tag = $('#quick_add').val().toLowerCase()
        if e.which is 13
            if tag.length > 0
                split_tags = tag.match(/\S+/g)
                $('#quick_add').val('')
                Meteor.call 'add_event', split_tags
                selected_theme_tags.clear()
                for tag in split_tags
                    selected_theme_tags.push tag

# Template.events_doc_view.helpers
#     tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

#     # event_tags: -> _.difference(@tags, 'event')
    
#     event_card_class: -> if @published then 'blue' else ''


# Template.events_doc_view.events
#     'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
