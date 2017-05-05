FlowRouter.route '/course/:slug/module/:module_id/downloads', 
    name: 'module_files'
    action: (params) ->
        BlazeLayout.render 'view_module',
            module_content: 'module_files_page'

FlowRouter.route '/course/:slug/downloads', 
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
        slug = FlowRouter.getParam('slug')
        Docs.find
            type:'module'
            course: slug

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
