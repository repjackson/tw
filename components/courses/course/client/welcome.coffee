FlowRouter.route '/course/sol/welcome', 
    name: 'course_welcome'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_welcome'



Template.course_welcome.onCreated ->
    # @autorun -> Meteor.subscribe 'course_by_slug', FlowRouter.getParam('course_slug')

Template.course_welcome.helpers
    # course: -> 


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
        _.where(@agreements, user_id: Meteor.userId() )

    agreed_date: ->
        if _.where(@agreements, user_id: Meteor.userId())
            agreement = _.where(@agreements, user_id: Meteor.userId())
            moment(agreement.date_signed).format("dddd, MMMM Do, h:mm a")

Template.view_terms_course.events
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
            Docs.update @_id,
                $addToSet: 
                    agreements: 
                        user_id: Meteor.userId()
                        date_signed: new Date()
    
    'click #remove_agreement': ->
        Docs.update @_id,
            $pull: 
                agreements: 
                    user_id: Meteor.userId()
        
        
        

Template.view_inspiration_course.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
