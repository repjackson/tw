FlowRouter.route '/course/:course_id/module/:module_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_module'


if Meteor.isClient
    Template.view_module.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')
    
    Template.view_module.onRendered ->
        Meteor.setTimeout ->
            $('#section_menu .item').tab()
        , 2000
    
    Template.view_questions.onRendered ->
        Meteor.setTimeout ->
            $('#question_menu .item').tab()
        , 2000
        
    Template.view_questions.helpers
        questions: -> 
            Questions.find
                section_id: @_id



    Template.view_module.helpers
        module: -> Modules.findOne FlowRouter.getParam('module_id')
        course: -> Courses.findOne FlowRouter.getParam('course_id')

        sections: ->
            Sections.find
                module_id: FlowRouter.getParam('module_id')

    Template.view_module.events
        'click .edit': ->
            module_id = FlowRouter.getParam('module_id')
            course_id = FlowRouter.getParam('course_id')
            FlowRouter.go "/course/#{course_id}/module/#{module_id}/edit"
