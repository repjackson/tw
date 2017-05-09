
FlowRouter.route '/course/:course_slug/downloads', 
    name: 'course_downloads'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_files'




Session.setDefault 'editing_id', null

Template.module_files.onCreated ->
    @autorun => Meteor.subscribe 'module_files', @data?._id

Template.module_files.helpers
    module_files: ->
        Files.find
            parent_module_id: @_id


Template.course_files.helpers
    modules: ->
        course_slug = FlowRouter.getParam('course_slug')
        Modules.find
            parent_course_slug: course_slug

Template.course_files.onRendered ->
    Meteor.setTimeout ->
        $('#course_modules_files_menu .item').tab()
    , 1000


Template.module_files.events
    'click #add_file': (e,t)->
        console.log @
        new_id = Files.insert
            parent_module_id: @_id
        Session.set 'editing_id', new_id

Template.file_item.events
    'click .edit_file': ->
        Session.set 'editing_id', @_id
