FlowRouter.route '/course/:course_id', 
    name: 'course_home'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'course_sales'

FlowRouter.route '/course/:course_id/modules', 
    name: 'course_modules'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_modules'

FlowRouter.route '/course/:course_id/members', 
    name: 'course_members'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_members'

FlowRouter.route '/course/:course_id/downloads', 
    name: 'course_downloads'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_files'

FlowRouter.route '/course/:course_id/welcome', 
    name: 'course_welcome'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_welcome'

FlowRouter.route '/course/:course_id/reminders', 
    name: 'course_reminders'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_reminders'


if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.view_course.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
        
        in_course: -> Meteor.user()?.courses and @_id in Meteor.user().courses
    


    Template.course_modules.helpers
        modules: -> Modules.find { }, sort: number: 1
            



    Template.course_sales.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')

    Template.course_sales.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
    
    Template.course_sales.events
        'click .buy_course': ->
            Session.set 'cart_item', @_id
            FlowRouter.go '/cart'

    
    Template.view_course.events
        'click #edit_course': ->
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/#{course_id}/edit"
            
        'click #add_module': ->
            course_id = FlowRouter.getParam('course_id')
            new_module_id = Modules.insert 
                course_id:course_id 
            FlowRouter.go "/course/#{course_id}/module/#{new_module_id}/edit"
            



    Template.course_welcome.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')

    Template.course_welcome.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')


    Template.course_welcome.onRendered ->
        Meteor.setTimeout ->
            $('#course_welcome_menu .item').tab()
        , 1000

    # Template.course_welcome.helpers
    #     agreements: ->
    #         Agreements.find()

    Template.edit_welcome_course.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
        
        course_welcome_context: ->
            @current_doc = Courses.findOne FlowRouter.getParam('course_id')
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
            
            course_id = FlowRouter.getParam('course_id')
    
            Courses.update course_id,
                $set: course_welcome_content: html
                
        'click #save_welcome_content': ->
            Session.set 'editing_id', null

    Template.view_welcome_course.events
        'click #edit_welcome_content': ->
            Session.set 'editing_id', @_id


    Template.edit_terms_course.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
        
        course_terms_context: ->
            @current_doc = Courses.findOne FlowRouter.getParam('course_id')
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

    Template.edit_terms_course.events
        'blur .froala-container': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            course_id = FlowRouter.getParam('course_id')
    
            Courses.update course_id,
                $set: course_terms_content: html
                
        'click #save_terms_content': ->
            Session.set 'editing_id', null

    Template.view_terms_course.events
        'click #edit_terms_content': ->
            Session.set 'editing_id', @_id



    Template.edit_inspiration_course.helpers
        course: -> Courses.findOne FlowRouter.getParam('course_id')
        
        course_inspiration_context: ->
            @current_doc = Courses.findOne FlowRouter.getParam('course_id')
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
            
            course_id = FlowRouter.getParam('course_id')
    
            Courses.update course_id,
                $set: course_inspiration_content: html
                
        'click #save_inspiration_content': ->
            Session.set 'editing_id', null

    Template.view_inspiration_course.events
        'click #edit_inspiration_content': ->
            Session.set 'editing_id', @_id


if Meteor.isServer
    Meteor.methods 
        enroll: (course_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: course_id