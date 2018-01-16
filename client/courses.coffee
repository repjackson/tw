FlowRouter.route '/courses', action: ->
    BlazeLayout.render 'layout', 
        main: 'courses'

Template.view_courses.onCreated ->
    @autorun -> Meteor.subscribe 'usernames'
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type = 'course'
            parent_id = null
            author_id = null
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



Template.view_courses.helpers
    courses: -> Docs.find {type: 'course'}


            
Template.view_courses.events
    'click #add_course': ->
        id = Docs.insert
            type: 'course'
        FlowRouter.go "/edit/#{id}"
        
        

Template.view_course.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.view_course.helpers
    course: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.edit_course.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.edit_course.helpers
    course: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.edit_course.events
    'click #delete_course': ->
        swal {
            title: 'Delete check in?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            course = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove course._id, ->
                FlowRouter.go "/courses"        