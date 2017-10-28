FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'usernames'
    
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type = null
            author_id = null
            parent_id = FlowRouter.getParam('doc_id')
            tag_limit = 20
            doc_limit = 69
            view_published = null
            view_read = null
            view_bookmarked = null
            view_resonates = null
            view_complete = null
            view_images = null
            view_lightbank_type = null

            )

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    doc_template: -> Docs.findOne type: 'doc_template'
    view_type_template: -> "view_#{@type}"
    is_field: -> @type is 'field'        

    younger_sibling: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.number
            previous_number = doc.number - 1
            Docs.findOne
                group: doc.group
                parent_id: doc.parent_id
                number: previous_number

    older_sibling: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.number
            next_number = doc.number + 1
            Docs.findOne
                group: doc.group
                parent_id: doc.parent_id
                number: next_number

    components: ->        
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.components
        
        # Docs.find
        #     type: 'component'

    # slug_exists: ->
    #     doc = Docs.findOne FlowRouter.getParam('doc_id')
    #     # console.log @
    #     # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
    #     if doc["#{@slug}"]? then true else false
        
        
    main_column_class: ->
        if Session.equals 'editing', true then 'ten wide column' else 'fourteen wide column'
        
    branch_button_class: -> if @parent_type is 'branch' then 'blue' else 'basic'
    twig_button_class: -> if @parent_type is 'twig' then 'blue' else 'basic'
    leaf_button_class: -> if @parent_type is 'leaf' then 'blue' else 'basic'
        
    is_branch: -> @parent_type is 'branch'
    is_twig: -> @parent_type is 'twig'
    is_leaf: -> @parent_type is 'leaf'
    
Template.view_doc.events
    'click #make_branch': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_type: 'branch'

    'click #make_twig': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_type: 'twig'
    
    'click #make_leaf': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_type: 'leaf'
    
    'click #create_parent': ->
        new_parent_id = Docs.insert {}
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: new_parent_id
        FlowRouter.go "/view/#{new_parent_id}" 
        
    
Template.field_menu.onCreated ->
    @autorun -> Meteor.subscribe 'components'


Template.field_menu.helpers
    unselected_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        values = _.pluck doc.components, 'field_id'
        Docs.find
            type: 'component'
            slug: $nin: values
            
Template.field_menu.events
    'click .select_component': ->
        # console.log @
        slug = @slug
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.update doc._id,
            $addToSet:
                components:
                    type: 'field'
                    field_id: slug
            
            
            
Template.field_component.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    component_segment_class: -> if Session.get 'editing' then '' else 'basic'    
            
    
Template.field_component.events
    'click .remove_component': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @
        Docs.update doc._id,
            $pull: components: @
            