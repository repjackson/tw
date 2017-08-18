FlowRouter.route '/course/sol/welcome', 
    name: 'course_welcome'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_welcome'




Template.course_welcome.onRendered ->
    Meteor.setTimeout ->
        $('#course_welcome_menu .item').tab()
    , 1000

Template.welcome_video.onCreated ->
    @autorun -> Meteor.subscribe 'sol_signers'
    @autorun -> Meteor.subscribe 'sol_progress'


Template.welcome_video.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000

Template.welcome_video.helpers
    welcome_video_watched: ->
        sol_progress_doc = 
            Docs.findOne
                tags: $all: ["sol", "course progress"]
                author_id: Meteor.userId()
        console.log sol_progress_doc
        if sol_progress_doc then return sol_progress_doc.watched_welcome_video


Template.welcome_video.helpers
    'click #mark_welcome_video_complete': ->
        sol_progress_doc = 
            Docs.findOne
                tags: $all: ["sol", "course progress"]
                author_id: Meteor.userId()
        console.log sol_progress_doc
        Docs.update sol_progress_doc._id, 
            $set:
                watched_welcome_video: true
        
        
        # Meteor.call 'calculate_sol_progress', (err,res)->
        #     # console.log res
        #     $('#section_percent_complete_bar').progress('set percent', res);
        #     # console.log $('#section_percent_complete_bar').progress('get percent');


    'click #unmark_video_complete': ->
        sol_progress_doc = 
            Docs.findOne
                tags: $all: ["sol", "course progress"]
                author_id: Meteor.userId()
        console.log sol_progress_doc
        Docs.update sol_progress_doc._id, 
            $set:
                watched_welcome_video: false
        
        # Meteor.call 'calculate_sol_progress', (err,res)->
        #     # console.log res
        #     $('#section_percent_complete_bar').progress('set percent', res);
        #     # console.log $('#section_percent_complete_bar').progress('get percent');




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

    agreements: ->
        course = Docs.findOne tags: ['course', 'sol']
        if course then course.agreements
            
        # if course 
        #     console.log course.agreements
        #     Meteor.users.find _id: $in: [course.agreements]
    user_object: ->
        # console.log @
        Meteor.users.findOne @user_id
        
        
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