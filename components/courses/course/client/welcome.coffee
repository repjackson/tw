FlowRouter.route '/course/:slug/welcome', 
    name: 'course_welcome'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_welcome'




Template.course_welcome.onRendered ->
    Meteor.setTimeout ->
        $('#course_welcome_menu .item').tab()
    , 1000



Template.view_welcome_course.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000


Template.view_terms_course.helpers
    has_agreed: ->
        course = Docs.findOne tags: ['course', 'sol']
        if course
            _.where(course.agreements, user_id: Meteor.userId() )

    agreed_date: ->
        course = Docs.findOne tags: ['course', 'sol']
        if _.where(course.agreements, user_id: Meteor.userId())
            agreement = _.where(course.agreements, user_id: Meteor.userId())
            moment(agreement.date_signed).format("dddd, MMMM Do, h:mm a")

Template.view_terms_course.events
    'click #edit_terms_content': ->
        Session.set 'editing_id', @_id

    'click #agree_to_terms': ->
        self = @
        swal {
            title: 'Agree to Terms?'
            text: 'This cannot be undone.'
            type: 'info'
            animation: true
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Agree'
            # confirmButtonColor: '#da5347'
        }, =>
            course = Docs.findOne tags: ['course', 'sol']
            # console.log course
            Docs.update course._id,
                $addToSet: 
                    agreements: 
                        user_id: Meteor.userId()
                        date_signed: new Date()
    
    'click #remove_agreement': ->
        course = Docs.findOne tags: ['course', 'sol']
        Docs.update course._id,
            $pull: 
                agreements: 
                    user_id: Meteor.userId()
        
        
        
Template.view_inspiration_course.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000