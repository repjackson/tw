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
            view_published = 
                if Roles.userIsInRole(Meteor.userId(), 'admin') then Session.get('view_published') else true 
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
        # console.log doc.type
        if doc.type
            # console.log typeof doc.type
            switch doc.type
                when 'journal' 
                    # console.log 'is journal'
                    return "view_#{@type}"
                when 'checkin' 
                    # console.log 'doc.type is lightbank'
                    return "view_#{@type}"
                when 'lightbank' 
                    # console.log 'doc.type is lightbank'
                    return "view_#{@type}"
                else 
                    # console.log 'new view doc'
                    return 'new_view_doc'
        else 
            # console.log 'new view doc'
            return 'new_view_doc'
    # is_field: -> 
    #     # console.log @type
    #     @type is 'field'        


Template.new_view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
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
        
        
    main_column_class: -> if Session.equals 'editing', true then 'eight wide column' else 'fourteen wide column'
    field_segment_class: -> if Session.equals 'editing', true then '' else 'basic compact'
        
    grid_button_class: -> if @child_view is 'grid' then 'blue' else 'basic'
    list_button_class: -> if @child_view is 'list' then 'blue' else 'basic'

    response_button_class: -> if @completion_type is 'response' then 'blue' else 'basic'
    mark_read_button_class: -> if @completion_type is 'mark_read' then 'blue' else 'basic'
    check_children_button_class: -> if @completion_type is 'check_children' then 'blue' else 'basic'
        
    grid_view: -> @child_view is 'grid'
    list_view: -> @child_view is 'list'
    
    response_completion: -> @completion_type is 'response'
    read_completion: -> @completion_type is 'mark_read'
    
    read: -> @read_by and Meteor.userId() in @read_by
    
    response_doc: -> 
        response_doc = Docs.findOne
            parent_id: FlowRouter.getParam('doc_id')
            author_id: Meteor.userId()
        if response_doc then return true else false
    
    
    
Template.new_view_doc.events
    'click .mark_read': (e,t)-> 
        Meteor.call 'mark_read', @_id, =>
            Meteor.call 'calculate_completion', @_id
        
    'click .mark_unread': (e,t)-> 
        Meteor.call 'mark_unread', @_id, =>
            Meteor.call 'calculate_completion', @_id
    
    'click #select_grid': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: child_view: 'grid'

    'click #select_list': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: child_view: 'list'
    
    'click #select_response_completion': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: completion_type: 'response'
        
    'click #select_mark_read_completion': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: completion_type: 'mark_read'
        
    'click #select_check_children_completion': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: completion_type: 'check_children'
    
    'click #create_parent': ->
        new_parent_id = Docs.insert {}
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: new_parent_id
        FlowRouter.go "/view/#{new_parent_id}" 
        
    'click #create_response': ->
        Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
            
        
    
# Template.field_menu.onCreated ->
    # @autorun -> Meteor.subscribe 'components'


Template.field_menu.helpers
    unselected_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        keys = _.keys doc
        Docs.find
            type: 'component'
            slug: $nin: keys
            
Template.field_menu.events
    'click .select_component': ->
        slug = @slug
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.update doc._id,
            $set: "#{slug}": ''
            
            
            
Template.response.onCreated ->
    @editing = new ReactiveVar(false)

Template.response.helpers
    editing_mode: -> Template.instance().editing.get()
    response: -> 
        Docs.findOne
            parent_id: FlowRouter.getParam('doc_id')
            author_id: Meteor.userId()
            
Template.response.events
    'click .edit_this': (e,t)-> t.editing.set true
    'click .save_doc': (e,t)-> 
        t.editing.set false
        Meteor.call 'calculate_completion', FlowRouter.getParam('doc_id')

    'blur #body_field': (e,t)->
        body_field = $(e.currentTarget).closest('#body_field').val()
        Docs.update @_id,
            $set: body: body_field


Template.list.helpers
    children: ->
        if Roles.userIsInRole(Meteor.userId(), 'admin')
            Docs.find {
                parent_id: FlowRouter.getParam 'doc_id'
            }, sort: number: 1
        else
            Docs.find {
                parent_id: FlowRouter.getParam 'doc_id'
                published: 1
            }, sort: number: 1


        
Template.grid.helpers
    children: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
        }, sort: number: 1


            