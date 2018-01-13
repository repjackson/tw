FlowRouter.route '/courses', action: ->
    BlazeLayout.render 'layout', 
        main: 'courses'

Template.courses.onCreated ->
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

Template.course_card.onCreated ->
    @autorun -> Meteor.subscribe 'usernames'



Template.courses.helpers
    courses: -> Docs.find {type: 'course'}

Template.course_card.helpers
    theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
    location_tag_class: -> if @valueOf() in selected_location_tags.array() then 'blue' else 'basic'

Template.course_card.events
    'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
    'click .location_tag': -> if @valueOf() in selected_location_tags.array() then selected_location_tags.remove(@valueOf()) else selected_location_tags.push(@valueOf())


            
Template.courses.events
    'click #add_course': ->
        id = Docs.insert
            type: 'course'
        FlowRouter.go "/course/#{id}/edit"
        
        
FlowRouter.route '/course/:doc_id/view', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_course'

Template.view_course.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.view_course.helpers
    course: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
FlowRouter.route '/course/:doc_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_course'

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
                FlowRouter.go "/course"        