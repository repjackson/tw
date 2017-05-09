FlowRouter.route '/course/:slug/welcome', 
    name: 'course_welcome'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_welcome'



Template.course_welcome.onCreated ->
    @autorun -> Meteor.subscribe 'course_by_slug', FlowRouter.getParam('slug')

Template.course_welcome.helpers
    course: -> Courses.findOne slug: FlowRouter.getParam('slug')


Template.course_welcome.onRendered ->
    Meteor.setTimeout ->
        $('#course_welcome_menu .item').tab()
    , 1000


Template.edit_welcome_course.helpers
    course: -> 
        Courses.findOne 
            slug: FlowRouter.getParam('slug')
    course_welcome_context: ->
        @current_doc = Courses.findOne slug: FlowRouter.getParam('slug')
        self = @
        {
            _value: self.current_doc.course_welcome_content
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }

Template.edit_welcome_course.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        Courses.update @_id,
            $set: course_welcome_content: html
            
    'click #save_welcome_content': ->
        Session.set 'editing_id', null




Template.welcome_transcript.helpers
    transcript: ->
        @current_doc = Courses.findOne @_id
        self = @
        {
            _value: self.current_doc.welcome_transcript
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            imageInsertButtons: ['imageByURL']
            tabSpaces: false
            height: 300
        }
    
        
Template.welcome_transcript.events
    'blur .transcript': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        Courses.update @_id,
            $set: welcome_transcript: html




Template.view_welcome_course.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000




Template.view_welcome_course.events
    'click #edit_welcome_content': ->
        Session.set 'editing_id', @_id


Template.edit_terms_course.helpers
    course: -> Courses.findOne slug: FlowRouter.getParam('slug')
    
    course_terms_context: ->
        @current_doc = Courses.findOne slug: FlowRouter.getParam('slug')
        self = @
        {
            _value: self.current_doc.course_terms_content
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }
        
Template.view_terms_course.helpers
    has_agreed: ->
        _.where(@agreements, user_id: Meteor.userId() )

    agreed_date: ->
        if _.where(@agreements, user_id: Meteor.userId())
            agreement = _.where(@agreements, user_id: Meteor.userId())
            moment(agreement.date_signed).format("dddd, MMMM Do, h:mm a")

Template.edit_terms_course.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        slug = FlowRouter.getParam('slug')

        Courses.update slug: slug,
            $set: course_terms_content: html
            
    'click #save_terms_content': ->
        Session.set 'editing_id', null

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
            Courses.update @_id,
                $addToSet: 
                    agreements: 
                        user_id: Meteor.userId()
                        date_signed: new Date()
    
    'click #remove_agreement': ->
        Courses.update @_id,
            $pull: 
                agreements: 
                    user_id: Meteor.userId()
        
        
        
        
Template.inspiration_transcript.helpers
    transcript: ->
        @current_doc = Courses.findOne @_id
        self = @
        {
            _value: self.current_doc.inspiration_transcript
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            imageInsertButtons: ['imageByURL']
            tabSpaces: false
            height: 300
        }
    
        
Template.inspiration_transcript.events
    'blur .transcript': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        Courses.update @_id,
            $set: inspiration_transcript: html




Template.view_inspiration_course.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000

        

Template.edit_inspiration_course.helpers
    course: -> Courses.findOne slug: FlowRouter.getParam('slug')
    
    course_inspiration_context: ->
        @current_doc = Courses.findOne slug: FlowRouter.getParam('slug')
        self = @
        {
            _value: self.current_doc.course_inspiration_content
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }

Template.edit_inspiration_course.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        Courses.update @_id,
            $set: course_inspiration_content: html
            
    'click #save_inspiration_content': ->
        Session.set 'editing_id', null

Template.view_inspiration_course.events
    'click #edit_inspiration_content': ->
        Session.set 'editing_id', @_id

