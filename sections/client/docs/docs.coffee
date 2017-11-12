FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'view_doc'
@selected_theme_tags = new ReactiveArray []

Template.theme_facet.helpers
    theme_tags: ->
        
        doc_count = Docs.find( parent_id:FlowRouter.getParam('doc_id') ).count()
        # if selected_theme_tags.array().length
        if 0 < doc_count < 3
            Tags.find { 
                # type:Template.currentData().type
                count: $lt: doc_count
                }, limit:20
        else
            Tags.find({}, limit:20)
            
            
    cloud_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push ' '
            when @index <= 10 then button_class.push 'small'
            when @index <= 15 then button_class.push 'tiny '
            when @index <= 20 then button_class.push ' mini'
        return button_class

    selected_theme_tags: -> selected_theme_tags.array()
    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }



Template.theme_facet.events
    'click .select_theme_tag': -> selected_theme_tags.push @name
    'click .unselect_theme_tag': -> selected_theme_tags.remove @valueOf()
    'click #clear_theme_tags': -> selected_theme_tags.clear()

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_theme_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_theme_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_theme_tags.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_theme_tags.push doc.name
        $('#search').val ''


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'doc', Session.get('inline_editing')
    # @autorun -> Meteor.subscribe 'my_children', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'usernames'
    # @autorun -> Meteor.subscribe 'components'
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            type = null
            author_id = null
            parent_id = FlowRouter.getParam('doc_id')
            tag_limit = 20
            doc_limit = 20
            view_voted = Session.get 'view_voted'
            view_public = Session.get 'view_public'
            view_published = null
                # if Session.equals('admin_mode', true) then Session.get('view_published') else true 
            inline_editing = Session.get('inline_editing')

            )
Template.view_doc.onRendered ->
    selected_theme_tags.clear()

Template.view_doc.helpers
    doc: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log doc
        return doc
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
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        limit = if doc.result_limit then parseInt(doc.result_limit) else 20 
        if doc
            if Session.get 'inline_editing'
                Docs.find Session.get('inline_editing')
            
            else
                Docs.find {
                    parent_id: FlowRouter.getParam 'doc_id'
                    }, {
                        sort: { timestamp: -1, points: -1, number: 1  }
                        limit: limit
                        }

    components: ->
        Docs.find
            # type: 'component'
            parent_id: 'MzHSPbvCYPngq2Dcz'
            
    slug_exists: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
        
    main_column_class: -> 
        if Session.equals 'page_editing', true 
            'ten wide column' 
        else if Session.get('inline_editing')
            'fourteen wide column'
        else
            'fourteen wide column'
        # else if @theme_tags_facet or @location_tags_facet or @intention_tags_facet or @username_facet
        #     'eight wide column'
        # else
        #     'fourteen wide column'
    field_segment_class: -> if Session.equals 'editing', true then '' else 'basic compact'
        
    
    response_completion: -> @completion_type is 'response'
    read_completion: -> @completion_type is 'mark_read'
    session_completion: -> @completion_type is 'session'
    
    read: -> @read_by and Meteor.userId() in @read_by
    
    response_doc: -> 
        response_doc = Docs.findOne
            parent_id: FlowRouter.getParam('doc_id')
            author_id: Meteor.userId()
        if response_doc then return true else false
    grid_view: -> @child_view is 'grid'
    list_view: -> @child_view is 'list'
    card_view: -> @child_view is 'cards'
    answer_view: -> @child_view is 'answers'
    q_a_view: -> @child_view is 'q_a'
    grandchild_list_view: -> @child_view is 'grandchild_list'
    quiz_view: -> @child_view is 'quiz'
    flash_card_view: -> @child_view is 'flash_cards'
    
    viewing_public: -> Session.equals 'view_public', true    
    
    can_see_filter_bar: -> 
        if Session.get('inline_editing') or @child_view is 'grid' or Session.get('page_editing') 
            false
        else
            true
    
    can_view_facet_bar: ->
        if Session.get('inline_editing') or Session.get('page_editing') 
            false
        else
            true
    
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
        Session.set 'inline_editing', new_id

      
    'click #admin_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        # FlowRouter.go("/view/#{new_id}")
        # Session.set 'editing', true
      
    'click #user_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        Session.set 'view_voted', null 
        Session.set 'inline_editing', new_id
      
    'click #toggle_admin_mode': ->
        if Session.equals('admin_mode', true) then Session.set('admin_mode', false)
        else if Session.equals('admin_mode', false) then Session.set('admin_mode', true)
    
    'click #toggle_view_mode': ->
        if Session.equals('view_public', true) then Session.set('view_public', false)
        else if Session.equals('view_public', false) then Session.set('view_public', true)
