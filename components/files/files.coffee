@Files = new Meteor.Collection 'files'

Files.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Files.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

if Meteor.isClient
    FlowRouter.route '/course/:course_id/module/:module_id/downloads', 
        name: 'module_files'
        action: (params) ->
            BlazeLayout.render 'view_module',
                module_content: 'module_files_page'
    
    Session.setDefault 'editing_id', null
    
    Template.module_files.onCreated ->
        @autorun => Meteor.subscribe 'module_files', @data?._id

    Template.module_files.helpers
        module_files: ->
            Files.find
                module_id: @_id
    
    Template.module_files_page.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')

    
    Template.module_files_page.helpers
        module_ob: -> 
            module_ob = Modules.findOne FlowRouter.getParam('module_id')
            module_ob
    
    Template.course_files.helpers
        modules: ->
            course_id = FlowRouter.getParam('course_id')
            Modules.find
                course_id: course_id
    
    Template.course_files.onRendered ->
        Meteor.setTimeout ->
            $('#course_modules_files_menu .item').tab()
        , 1000


    Template.module_files.events
        'click #add_file': (e,t)->
            new_id = Files.insert
                module_id: @_id
            Session.set 'editing_id', new_id

    Template.file_item.events
        'click .edit_file': ->
            Session.set 'editing_id', @_id
    

if Meteor.isServer
    Files.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    publishComposite 'module_files', (module_id)->
        {
            find: ->
                Files.find module_id: module_id
            # children: [
            #     { find: (question) ->
            #         Answers.find
            #             question_id: question._id
            #     }
            # ]
        }