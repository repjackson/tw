if Meteor.isClient
    FlowRouter.route '/course/:course_id/module/:module_id/downloads', 
        name: 'module_files'
        action: (params) ->
            BlazeLayout.render 'view_module',
                module_content: 'module_files_page'
    
    FlowRouter.route '/course/:course_id/downloads', 
        name: 'course_downloads'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_files'
    

    
    
    
    Session.setDefault 'editing_id', null
    
    Template.module_files.onCreated ->
        @autorun => Meteor.subscribe 'module_files', @data?._id

    Template.module_files.helpers
        module_files: ->
            Docs.find
                type: 'file'
                module_id: @_id
    
    Template.module_files_page.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')

    
    Template.module_files_page.helpers
        module_ob: -> 
            module_ob = Docs.findOne
                _id: FlowRouter.getParam('module_id')
                type: 'module'
            module_ob
    
    Template.course_files.helpers
        modules: ->
            course_id = FlowRouter.getParam('course_id')
            Docs.find
                type:'module'
                course_id: course_id
    
    Template.course_files.onRendered ->
        Meteor.setTimeout ->
            $('#course_modules_files_menu .item').tab()
        , 1000


    Template.module_files.events
        'click #add_file': (e,t)->
            new_id = Docs.insert
                type: 'file'
                module_id: @_id
            Session.set 'editing_id', new_id

    Template.file_item.events
        'click .edit_file': ->
            Session.set 'editing_id', @_id
    

if Meteor.isServer
    publishComposite 'module_files', (module_id)->
        {
            find: ->
                Docs.find 
                    type: 'file'
                    module_id: module_id
            # children: [
            #     { find: (question) ->
            #         Answers.find
            #             question_id: question._id
            #     }
            # ]
        }