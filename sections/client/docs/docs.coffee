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

    one_doc: -> Docs.find().count() is 1

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

    selected_theme_tags: -> selected_theme_tags.array()



Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'doc_template', FlowRouter.getParam('doc_id')

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
        doc_template = Docs.findOne type: 'doc_template'
        doc_template?.components
        
        # Docs.find
        #     type: 'component'

    slug_exists: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
    
Template.view_doc.events
    'click #create_doc_template': ->
        console.log @
        Docs.insert
            type: 'doc_template'
            doc_type: @type
            components: []
    
    
Template.children.helpers
    children: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
        }, sort: number: 1


Template.children.events
    'click #add_child': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            # type: 'section'
        

Template.field_menu.onCreated ->
    @autorun -> Meteor.subscribe 'components'


Template.field_menu.helpers
    unselected_fields: ->
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @slug
        doc_template = Docs.findOne type: 'doc_template'
        if doc_template
            values = _.pluck doc_template.components, 'field_id'
        Docs.find
            type: 'component'
            slug: $nin: values
            
Template.field_menu.events
    'click .select_component': ->
        # console.log @
        slug = @slug
        doc_template = Docs.findOne type: 'doc_template'
        Docs.update doc_template._id,
            $addToSet:
                components:
                    type: 'field'
                    field_id: slug
            
            
Template.component_menu.onCreated ->
    @autorun -> Meteor.subscribe 'components'

            
Template.component_menu.events
    'click #add_group': ->
        # console.log Docs.findOne type: 'doc_template'
        doc_template = Docs.findOne type: 'doc_template'
        group = prompt 'Group name:'
        Docs.update doc_template._id,
            $addToSet: 
                components: 
                    type: 'group'
                    group: group
            
    'click #add_field': ->
        # console.log Docs.findOne type: 'doc_template'
        doc_template = Docs.findOne type: 'doc_template'
        Docs.update doc_template._id,
            $addToSet: components: {type: 'field'}
            
            
Template.field_component.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    component_segment_class: -> if Session.get 'editing' then '' else 'basic'    
Template.group_component.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    component_segment_class: -> if Session.get 'editing' then '' else 'basic'    
    
    group_children: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.find {
            parent_id: doc._id
            group: @group
            }, sort: number: 1
            
    
Template.field_component.events
    'click .remove_component': ->
        doc_template = Docs.findOne type: 'doc_template'
        console.log @
        Docs.update doc_template._id,
            $pull: components: @
Template.group_component.events
    'click .remove_component': ->
        doc_template = Docs.findOne type: 'doc_template'
        console.log @
        Docs.update doc_template._id,
            $pull: components: @
            
    # 'blur #group': (e,t)->
    #     group = $(e.currentTarget).closest('#group').val()
    #     doc_template = Docs.findOne type: 'doc_template'
    #     console.log @
    #     Docs.update { _id: doc_template._id, components: @},
    #         $set: 
    #             "components.$":  
    #                 group: group
        
            