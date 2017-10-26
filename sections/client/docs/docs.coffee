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
        if Session.equals 'editing', true then 'twelve wide column' else 'fourteen wide column'
        
    
Template.view_doc.events
    'click #disallow_responses': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: responses_allowed: false

    'click #allow_responses': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: responses_allowed: true
    
    'click #create_parent': ->
        new_parent_id = Docs.insert {}
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: new_parent_id
        FlowRouter.go "/view/#{new_parent_id}" 
        
    
    
Template.responses.helpers
    responses: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
        }, sort: number: 1

Template.children.helpers
    children: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
            # author_id: Meteor.userId()
            # type: 'child'
        }, sort: number: 1


Template.children.events
    'click #add_child': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            type: 'child'
        
Template.responses.events
    'click #add_response': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            type: 'response'
        
Template.response.onCreated ->
    @editing = new ReactiveVar(false)

Template.response.helpers
    editing_mode: -> Template.instance().editing.get()

Template.response.events
    'click .edit_this': (e,t)-> t.editing.set true
    'click .save_doc': (e,t)-> t.editing.set false

    'keyup #tag_input': (e,t)->
        e.preventDefault()
        val = $('#tag_input').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update Template.currentData()._id,
                        $addToSet: tags: val
                    $('#tag_input').val ''
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(Template.currentData()._id).tags.slice -1
            #         $('#theme_tag_select').val result[0]
            #         Docs.update Template.currentData()._id,
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: tags: tag
        $('#tag_input').val(tag)



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
Template.group_component.events
    'click .remove_component': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @
        Docs.update doc._id,
            $pull: components: @
            