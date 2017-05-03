if Meteor.isClient
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

