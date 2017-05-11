FlowRouter.route '/course/:course_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_course'

Template.edit_course.onCreated ->
    @autorun -> Meteor.subscribe 'sol_course'


Template.edit_course.helpers
    course: -> Docs.findOne tags: ['course', 'sol']
    