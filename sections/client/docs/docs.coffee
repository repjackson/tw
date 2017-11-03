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
            doc_limit = 20
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
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
        
        
    # main_column_class: -> if Session.equals 'editing', true then 'ten wide column' else 'fourteen wide column'
    field_segment_class: -> if Session.equals 'editing', true then '' else 'basic compact'
        
    
    response_completion: -> @completion_type is 'response'
    read_completion: -> @completion_type is 'mark_read'
    
    read: -> @read_by and Meteor.userId() in @read_by
    
    response_doc: -> 
        response_doc = Docs.findOne
            parent_id: FlowRouter.getParam('doc_id')
            author_id: Meteor.userId()
        if response_doc then return true else false
    grid_view: -> @child_view is 'grid'
    list_view: -> @child_view is 'list'
    card_view: -> @child_view is 'cards'
    check_ins_view: -> @child_view is 'check_ins'
    
    
Template.doc_editing_sidebar.helpers
    toggle_theme_tags_class: -> if @theme_tags_facet is true then 'blue' else 'basic'
    
    
Template.new_view_doc.events
    'click .mark_read': (e,t)-> 
        Meteor.call 'mark_read', @_id, =>
            Meteor.call 'calculate_completion', @_id
        
    'click .mark_unread': (e,t)-> 
        Meteor.call 'mark_unread', @_id, =>
            Meteor.call 'calculate_completion', @_id
    
    'click #create_parent': ->
        new_parent_id = Docs.insert {}
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: new_parent_id
        FlowRouter.go "/view/#{new_parent_id}" 
        
    'click #create_response': ->
        Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
      
      
    'click #add_child': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        FlowRouter.go("/view/#{new_id}")
        Session.set 'editing', true
      
      
            
Template.doc_editing_sidebar.events        
# Template.field_menu.onCreated ->
    # @autorun -> Meteor.subscribe 'components'
    'click #delete_doc': ->
        swal {
            title: 'Remove Document?'
            type: 'warning'
            animation: true
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Docs.remove @_id
            swal 'Removed', 'success'
            Session.set 'editing', false
            FlowRouter.go "/view/#{@parent_id}"


Template.field_menu.helpers
    unselected_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        keys = _.keys doc
        Docs.find
            type: 'component'
            slug: $nin: keys
            
Template.field_menu.events
    'click .select_component': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        slug = @slug
        # console.log @field_type
        if @field_type is 'array'
            Docs.update doc._id,
                $set: "#{slug}": []
        else
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
            }, sort: 
                number: 1
                timestamp: -1
        else
            Docs.find {
                parent_id: FlowRouter.getParam 'doc_id'
                published: 1
            }, sort: 
                number: 1
                timestamp: -1


        
Template.grid.helpers
    children: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
        }, sort: number: 1

Template.cards.helpers
    children: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
        }, sort: 
            number: 1
            timestamp: -1

Template.check_ins.helpers
    children: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
        }, sort: 
            number: 1
            timestamp: -1


Template.doc_editing_sidebar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
            
# Template.doc_editing_main.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 1000
            
            
Template.card.events
    'click .expand_card': (e,t)->
        $(e.currentTarget).closest('.card').toggleClass 'fluid'

Template.toggle_key.helpers
    toggle_key_button_class: -> 
        # console.log @key
        # console.log Template.parentData()
        # console.log Template.parentData()["#{@key}"]
        if @value
            if Template.parentData()["#{@key}"] is @value then 'blue' else 'basic'
        else if Template.parentData()["#{@key}"] is true then 'blue' else 'basic'


Template.toggle_key.events
    'click #toggle_key': ->
        # console.log @
        if @value
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": "#{@value}"
        else if Template.parentData()["#{@key}"] is true
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": false
        else
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": true
            
    
