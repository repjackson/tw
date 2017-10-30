FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'usernames'
    @autorun -> Meteor.subscribe 'components'

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
    view_type_template: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        console.log doc.type
        if doc.type
            if doc.type is 'journal' or 'checkin' or 'lightbank' 
                console.log 'true'
                return "view_#{@type}"
        else 
            console.log 'false'
            return 'new_view_doc'
    # is_field: -> 
    #     # console.log @type
    #     @type is 'field'        

Template.new_view_doc.helpers
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


    view_template_old: -> 
        Meteor.setTimeout (->
        ), 500
        # return false
    view_new: -> 
        Meteor.setTimeout (->
            doc = Docs.findOne FlowRouter.getParam('doc_id')
            console.log doc.type
            if doc.type
                if doc.type is 'journal' or 'checkin' or 'lightbank' 
                    console.log 'dont view new'
                    return false
            else 
                console.log 'view new'
                true
        ), 500
        # return false

    components: ->        
    #     doc = Docs.findOne FlowRouter.getParam('doc_id')
    #     doc.components
        
        Docs.find
            type: 'component'

    slug_exists: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log @
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
        
        
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
    # @autorun -> Meteor.subscribe 'components'


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
            
            
            
# Template.group_component.events
#     'click .remove_component': ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         # console.log @
#         Docs.update doc._id,
#             $pull: components: @

# Template.responses.events
#     'click #add_response': ->
#         Docs.insert
#             parent_id: FlowRouter.getParam 'doc_id'
#             type: 'response'
        
# Template.response.onCreated ->
#     @editing = new ReactiveVar(false)

# Template.response.helpers
#     editing_mode: -> Template.instance().editing.get()

# Template.response.events
#     'click .edit_this': (e,t)-> t.editing.set true
#     'click .save_doc': (e,t)-> t.editing.set false

#     'keyup #tag_input': (e,t)->
#         e.preventDefault()
#         val = $('#tag_input').val().toLowerCase().trim()
#         switch e.which
#             when 13 #enter
#                 unless val.length is 0
#                     Docs.update Template.currentData()._id,
#                         $addToSet: tags: val
#                     $('#tag_input').val ''
#             # when 8
#             #     if val.length is 0
#             #         result = Docs.findOne(Template.currentData()._id).tags.slice -1
#             #         $('#theme_tag_select').val result[0]
#             #         Docs.update Template.currentData()._id,
#             #             $pop: tags: 1


#     'click .doc_tag': (e,t)->
#         tag = @valueOf()
#         Docs.update Template.currentData()._id,
#             $pull: tags: tag
#         $('#tag_input').val(tag)


# Template.responses.helpers
#     responses: ->
#         Docs.find {
#             parent_id: FlowRouter.getParam 'doc_id'
#         }, sort: number: 1

Template.leaves.helpers
    leaves: ->
        if Roles.userIsInRole 'admin'
            Docs.find {
                parent_id: FlowRouter.getParam 'doc_id'
                # author_id: Meteor.userId()
                # type: 'child'
            }, sort: number: 1
        else
            Docs.find {
                parent_id: FlowRouter.getParam 'doc_id'
                # author_id: Meteor.userId()
                # type: 'child'
                published: 1
            }, sort: number: 1


Template.leaves.events
    'click #add_leaf': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            # type: 'child'
        
Template.leaf.helpers
    published_state_icon: ->
        switch @published
            when 1 then 'eye'
            when 0 then 'ignore'
            when -1 then 'invisible'
        
        
Template.twigs.helpers
    twigs: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
            # author_id: Meteor.userId()
            # published: 1
        }, sort: number: 1


Template.twigs.events
    'click #add_twig': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            type: 'twig'
        
            