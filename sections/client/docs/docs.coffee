FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'


Template.docs.onCreated -> 
    @autorun -> Meteor.subscribe('docs', selected_theme_tags.array(), type=null, 5)

Template.docs.helpers
    docs: -> 
        Docs.find { }, 
            sort:
                tag_count: 1
            limit: 10

    one_doc: -> 
        Docs.find().count() is 1

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

    selected_theme_tags: -> selected_theme_tags.array()



Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'components'

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    view_type_template: -> "view_#{@type}"
    
    components: ->        
        Docs.find
            type: 'component'

    slug_exists: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
    
    
    
Template.children.helpers
    children: ->
        Docs.find
            parent_id: FlowRouter.getParam 'doc_id'
            # type: 'section'

Template.children.events
    'click #add_child': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            # type: 'section'
        
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