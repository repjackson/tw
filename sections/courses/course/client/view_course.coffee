# loggedIn = FlowRouter.group
#     triggersEnter: [ ->
#         unless Meteor.loggingIn() or Meteor.userId()
#             route = FlowRouter.current()
#         unless route.route.name is 'login'
#             Session.set 'redirectAfterLogin', route.path
#             FlowRouter.go 'login'
#         ]




# FlowRouter.route '/course/sol', 
#     name: 'course_home'
#     triggersEnter: [ (context, redirect) ->
#         if Meteor.user() and Roles.userIsInRole(Meteor.userId(), 'sol_member') or Roles.userIsInRole(Meteor.userId(), 'sol_demo')
#             redirect "/course/sol/dashboard"
#         else 
#             redirect "/course/sol/sales"
#     ]





# FlowRouter.route '/course/:slug/reminders', 
#     name: 'course_reminders'
#     action: (params) ->
#         BlazeLayout.render 'view_course',
#             course_content: 'course_reminders'

# FlowRouter.route '/register-sol', 
#     name: 'register-sol'
#     action: (params) ->
#         BlazeLayout.render 'layout',
#             main: 'register_sol'



Template.view_course.onCreated ->
    # @autorun -> Meteor.subscribe 'doc_by_tags', ['course','sol']
    # @autorun -> Meteor.subscribe 'sol_members', selected_course_member_tags.array()
    # @autorun -> Meteor.subscribe 'sol_signers'
    # @autorun -> Meteor.subscribe 'sol_progress'
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'components'


# Template.view_course.onRendered ->
#     self = @
#     if @subscriptionsReady()
#         @autorun =>
#         # console.log Session.get 'section_number'
#             Meteor.setTimeout ->
#                 # $('.ui.accordion').accordion()            
#                 course_progress_doc = 
#                     Docs.findOne
#                         type: 'course_progress'
#                         author_id: Meteor.userId()
#                 # console.log course_progress_doc
#                 if course_progress_doc
#                     $('#sol_percent_complete_bar').progress(
#                         percent: course_progress_doc.sol_progress_percent
#                         autoSuccess: false
#                         );
#             , 500


Template.view_course.helpers
    doc: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')

    components: ->        
        Docs.find
            type: 'component'

    slug_exists: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
        
    # has_agreed: ->
    #     course = Docs.findOne tags: ['course', 'sol']
    #     if course
    #         _.where(course.agreements, user_id: Meteor.userId() )

    # course_progress_doc: ->
    #     doc = Docs.findOne
    #         type: 'course_progress'
    #         author_id: Meteor.userId()
    #     # console.log doc
    #     doc
        
    # welcome_icon_class: ->
    #     course_progress_doc = 
    #         Docs.findOne
    #             type: 'course_progress'
    #             author_id: Meteor.userId()
    #     if course_progress_doc and course_progress_doc.welcome_complete then 'yellow' else ''        

Template.sections.helpers
    sections: ->
        Docs.find
            parent_id: FlowRouter.getParam 'doc_id'
            type: 'section'

Template.sections.events
    'click #add_section': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            type: 'section'
        
Template.view_course.events
    # 'click #add_module': ->
    #     slug = FlowRouter.getParam('slug')
    #     new_module_id = Modules.insert
    #         parent_course_slug:slug 
    #     FlowRouter.go "/course/#{slug}/module/#{new_module_id}/edit"
            
    # 'click #calculate_sol_progress': ->
    #     Meteor.call 'calculate_sol_progress', (err, res)->
    #         $('#sol_percent_complete_bar').progress('set percent', res);


Template.component_menu.onCreated ->
    @autorun -> Meteor.subscribe 'components'


Template.component_menu.helpers
    unselected_components: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        keys = _.keys doc
        Docs.find
            type: 'component'
            slug: $nin: keys
            
Template.component_menu.events
    'click .select_component': ->
        # console.log @
        slug = @slug
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "#{slug}": ''