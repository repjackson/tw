FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        selected_theme_tags.clear()
        BlazeLayout.render 'layout',
            main: 'view_doc'

FlowRouter.route '/edit/:doc_id', 
    name: 'edit'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'edit_doc'

Template.view_doc.onRendered ->
    selected_theme_tags.clear()
    
Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'my_children', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'usernames'
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    @autorun => Meteor.subscribe 'completors', FlowRouter.getParam('doc_id')
    # @autorun => 
    #     Meteor.subscribe('facet', 
    #         selected_theme_tags.array()
    #         selected_author_ids.array()
    #         selected_location_tags.array()
    #         selected_intention_tags.array()
    #         selected_timestamp_tags.array()
    #         type = null
    #         author_id = null
    #         parent_id = FlowRouter.getParam('doc_id')
    #         tag_limit = 20
    #         doc_limit = 20
    #         view_published = 
    #             if Session.equals('admin_mode', true) then true else Session.get('view_published')
    #         view_read = null
    #         view_bookmarked = null
    #         view_resonates = null
    #         view_complete = null
    #         view_images = null
    #         view_lightbank_type = null

    #         )


Template.edit_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'my_children', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'usernames'
    @autorun => Meteor.subscribe 'completors', FlowRouter.getParam('doc_id')


Template.edit_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    editing_template: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        "edit_#{doc.type}"

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    viewing_template: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        "view_#{doc.type}"

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

    completors: ->
        if @completed_by
            if @completed_by.length > 0
        # console.log @completed_by
                Meteor.users.find _id: $in: @completed_by
        else 
            false
        
    
    response_completion: -> @completion_type is 'response'
    read_completion: -> @completion_type is 'mark_read'
    session_completion: -> @completion_type is 'session'
    
    read: -> @read_by and Meteor.userId() in @read_by
    
    response_doc: -> 
        response_doc = Docs.findOne
            parent_id: FlowRouter.getParam('doc_id')
            author_id: Meteor.userId()
        if response_doc then return true else false
    
    q_a_view: -> @child_view is 'q_a'
    grandchild_list_view: -> @child_view is 'grandchild_list'
    quiz_view: -> @child_view is 'quiz'
    
    is_editing_session_id: -> Session.get 'editing_session_id'

    
Template.edit_doc.helpers


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

      
    'click #calculate_completion': ->
        console.log 'hi', FlowRouter.getParam('doc_id')
        Meteor.call 'calculate_completion', FlowRouter.getParam('doc_id')
      
    'click #admin_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        # FlowRouter.go("/view/#{new_id}")
        # Session.set 'editing', true
      
    'click #user_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        Session.set 'editing_id', new_id
      
    'click #new_session': ->
        new_session_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
            type: 'session'
        Session.set 'editing_session_id', new_session_id
      
    'click #add_older_sibling': ->
        new_older_sibling_id = Docs.insert
            number: @number+1
            parent_id: @parent_id
        FlowRouter.go "/view/#{new_older_sibling_id}" 

      
      
            
Template.edit_doc.events        
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
            Docs.update doc._id,
                $pull: "child_fields": @slug
        else
            Docs.update doc._id,
                $addToSet: "child_fields": @slug


    'click #move_up': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        parent = Docs.findOne doc.parent_id
        
        if confirm 'Move above parent?'
            # console.log @parent_id
            Docs.update doc._id,
                $set: parent_id: parent.parent_id
            




# Template.response.onCreated ->
#     @editing = new ReactiveVar(true)

# Template.response.helpers
#     editing_mode: -> Template.instance().editing.get()
#     response: -> 
#         Docs.findOne
#             parent_id: FlowRouter.getParam('doc_id')
#             author_id: Meteor.userId()
            
# Template.response.events
#     'click .edit_this': (e,t)-> t.editing.set true
#     'click .save_doc': (e,t)-> 
#         t.editing.set false
#         Session.set 'editing_id', null
#         Meteor.call 'calculate_completion', FlowRouter.getParam('doc_id')

#     'blur #text': (e,t)->
#         text = $(e.currentTarget).closest('#text').val()
#         Docs.update @_id,
#             $set: body: text




        
Template.edit_doc.onRendered ->
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
            
    
    
Template.editing_session_question.helpers
    response: ->
        Docs.findOne 
            author_id: Meteor.userId()
            parent_id: @_id
            
Template.editing_session_question.onCreated -> 
    Meteor.subscribe 'author', @data._id
    Meteor.subscribe 'child_docs', @data._id
            
Template.editing_session_question.events
    'click .create_response': ->
        new_id = Docs.insert
            parent_id: @_id
        Session.set 'editing_id', new_id

      
Template.boilerplate.onCreated ->
    @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
      
      
      

Template.boilerplate.helpers
    children: -> 
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
        }, sort: number: 1

        
