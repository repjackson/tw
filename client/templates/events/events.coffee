Template.view_events.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_theme_tags.array(), 'event')


Template.view_events.helpers
    events: -> Docs.find {type: 'event'}
            
Template.view_events.events
    'click #add_event': ->
        id = Docs.insert
            type: 'event'
        FlowRouter.go "/event/#{id}"
        Session.set 'editing', true
        
        
Template.view_event.events
    'click #delete': ->
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            event = Docs.findOne FlowRouter.getParam('events_id')
            Docs.remove event._id, ->
                FlowRouter.go "/events"        