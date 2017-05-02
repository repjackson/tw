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

FlowRouter.route '/register-sol', 
    name: 'register-sol'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'register_sol'


if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    Template.view_course.helpers
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        
    Template.course_sales.helpers
        in_sol: -> Roles.userIsInRole(Meteor.userId(), 'sol_member')
        in_demo: -> Roles.userIsInRole(Meteor.userId(), 'sol_demo_member')
        course: -> Docs.findOne FlowRouter.getParam('course_id')

    Template.course_modules.helpers
        modules: -> Docs.find {type: 'module' }, sort: number: 1
            

    Template.course_sales.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')

    Template.course_sales.events
        'click #sign_up_demo': ->
            if Meteor.user() then Roles.addUsersToRoles(Meteor.userId(), 'sol_demo_member')
            else FlowRouter.go '/register-sol'

    
    Template.view_course.events
        'click #add_module': ->
            course_id = FlowRouter.getParam('course_id')
            new_module_id = Docs.insert
                type: 'module'
                course_id:course_id 
            FlowRouter.go "/course/#{course_id}/module/#{new_module_id}/edit"
            



    Template.course_welcome.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')

    Template.course_welcome.helpers
        course: -> Docs.findOne FlowRouter.getParam('course_id')


    Template.course_welcome.onRendered ->
        Meteor.setTimeout ->
            $('#course_welcome_menu .item').tab()
        , 1000

    # Template.course_welcome.helpers
    #     agreements: ->
    #         Agreements.find()

    Template.edit_welcome_course.helpers
        course: -> 
            Docs.findOne 
                _id: FlowRouter.getParam('course_id')
                type: 'course'
        course_welcome_context: ->
            @current_doc = Docs.findOne FlowRouter.getParam('course_id')
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
    
            Docs.update course_id,
                $set: course_welcome_content: html
                
        'click #save_welcome_content': ->
            Session.set 'editing_id', null

    Template.view_welcome_course.events
        'click #edit_welcome_content': ->
            Session.set 'editing_id', @_id


    Template.edit_terms_course.helpers
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        
        course_terms_context: ->
            @current_doc = Docs.findOne FlowRouter.getParam('course_id')
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
    
            Docs.update course_id,
                $set: course_terms_content: html
                
        'click #save_terms_content': ->
            Session.set 'editing_id', null

    Template.view_terms_course.events
        'click #edit_terms_content': ->
            Session.set 'editing_id', @_id



    Template.edit_inspiration_course.helpers
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        
        course_inspiration_context: ->
            @current_doc = Docs.findOne FlowRouter.getParam('course_id')
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
    
            Docs.update course_id,
                $set: course_inspiration_content: html
                
        'click #save_inspiration_content': ->
            Session.set 'editing_id', null

    Template.view_inspiration_course.events
        'click #edit_inspiration_content': ->
            Session.set 'editing_id', @_id



    Template.course_members.onCreated ->
        @autorun -> Meteor.subscribe 'sol_members'
        

    Template.course_members.helpers
        course_members: ->
            Meteor.users.find
                roles: $in: ['sol_member', 'sol_demo_member']

if Meteor.isServer
    Meteor.methods 
        enroll: (course_id)->
            Meteor.users.update Meteor.userId(),
                $addToSet: courses: course_id
                
    Meteor.publish 'sol_members', (course_id) ->
        Meteor.users.find
            roles: $in: ['sol_member', 'sol_demo_member']