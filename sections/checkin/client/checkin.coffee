FlowRouter.route '/checkin', action: ->
    BlazeLayout.render 'layout', 
        main: 'checkins'

Template.checkins.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type = 'checkin'
            author_id = null
            parent_id = FlowRouter.getParam('doc_id')
            tag_limit = 20
            doc_limit = 20
            view_published = 
                if Session.equals('admin_mode', true) then true else Session.get('view_published')
            view_read = null
            view_bookmarked = null
            view_resonates = null
            view_complete = null
            view_images = null
            view_lightbank_type = null

            )


Template.checkins.helpers
    checkins: -> Docs.find {type: 'checkin'}
            
Template.checkin.events
    'click #add_checkin': ->
        id = Docs.insert
            type: 'checkin'
        FlowRouter.go "/checkin/#{id}"
        Session.set 'editing', true
        
        
FlowRouter.route '/checkin/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'checkin'

Template.checkin.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.checkin.helpers
    checkin: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.checkin.events
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
            checkin = Docs.findOne FlowRouter.getParam('checkin_id')
            Docs.remove checkin._id, ->
                FlowRouter.go "/checkin"        