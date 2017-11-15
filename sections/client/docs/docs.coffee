FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'doc', Session.get('editing_id')
    # @autorun -> Meteor.subscribe 'my_children', FlowRouter.getParam('doc_id')
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
            doc_limit = 15
            view_published = 
                if Session.equals('admin_mode', true) then Session.get('view_published') else true 
            view_read = null
            view_bookmarked = null
            view_resonates = null
            view_complete = null
            view_images = null
            view_lightbank_type = null

            )

Template.view_doc.helpers
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

    children: ->
        if Session.get 'editing_id'
            Docs.find Session.get('editing_id')
        
        else if Roles.userIsInRole(Meteor.userId(), 'admin')
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


    components: ->        
        Docs.find
            # type: 'component'
            parent_id: 'MzHSPbvCYPngq2Dcz'
            

    slug_exists: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
        
        
    main_column_class: -> 
        if Session.equals 'editing', true 
            'ten wide column' 
        else if @child_view is 'nav'
            'fourteen wide column'
        else
            'eight wide column'
        # else if @theme_tags_facet or @location_tags_facet or @intention_tags_facet or @username_facet
        #     'eight wide column'
        # else
        #     'fourteen wide column'
    field_segment_class: -> if Session.equals 'editing', true then '' else 'basic compact'
    flash_card_class: -> if Session.equals 'view_mode', 'flash_cards' then 'blue' else 'basic'
    list_button_class: -> if Session.equals 'view_mode', 'list' then 'blue' else 'basic'
    cards_button_class: -> if Session.equals 'view_mode', 'cards' then 'blue' else 'basic'
        
    
    response_completion: -> @completion_type is 'response'
    read_completion: -> @completion_type is 'mark_read'
    session_completion: -> @completion_type is 'session'
    
    read: -> @read_by and Meteor.userId() in @read_by
    
    response_doc: -> 
        response_doc = Docs.findOne
            parent_id: FlowRouter.getParam('doc_id')
            author_id: Meteor.userId()
        if response_doc then return true else false
    nav_view: -> @child_view is 'nav'
    list_view: -> @child_view is 'list'
    answer_view: -> @child_view is 'answers'
    
    
    child_view: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.can_change_view_mode
            return Session.get('view_mode')
        else
            return 'list'
    
    q_a_view: -> @child_view is 'q_a'
    grandchild_list_view: -> @child_view is 'grandchild_list'
    quiz_view: -> @child_view is 'quiz'
    

    
Template.doc_editing_sidebar.helpers
    toggle_theme_tags_class: -> if @theme_tags_facet is true then 'blue' else 'basic'
    selected_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        keys = _.keys doc
        Docs.find
            # type: 'component'
            parent_id: 'MzHSPbvCYPngq2Dcz'
            slug: $in: keys
    
    child_field_class: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @slug in doc.child_fields then 'blue' else 'basic'
    
    components: ->        
        Docs.find
            # type: 'component'
            parent_id: 'MzHSPbvCYPngq2Dcz'

Template.view_doc.events
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
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        Session.set 'editing_id', new_id

      
    'click #view_flash_cards': -> Session.set 'view_mode', 'flash_cards'

    'click #view_list': -> Session.set 'view_mode', 'list'
    'click #view_cards': -> Session.set 'view_mode', 'cards'

      
      
      
      
    'click #admin_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        # FlowRouter.go("/view/#{new_id}")
        # Session.set 'editing', true
      
    'click #user_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        Session.set 'editing_id', new_id
      
      
            
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

    'click .select_child_field': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.child_fields and @slug in doc.child_fields
            Docs.update FlowRouter.getParam('doc_id'),
                $pull: "child_fields": @slug
        else
            Docs.update FlowRouter.getParam('doc_id'),
                $addToSet: "child_fields": @slug

Template.field_menu.helpers
    unselected_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        keys = _.keys doc
        Docs.find
            # type: 'component'
            parent_id: 'MzHSPbvCYPngq2Dcz'
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
    @editing = new ReactiveVar(true)

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
        Session.set 'editing_id', null
        Meteor.call 'calculate_completion', FlowRouter.getParam('doc_id')

    'blur #text': (e,t)->
        text = $(e.currentTarget).closest('#text').val()
        Docs.update @_id,
            $set: body: text




        
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
            
    
