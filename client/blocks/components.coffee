
Template.resonates_list.helpers
    resonates_with_people: ->
        if @favoriters
            if @favoriters.length > 0
        # console.log @favoriters
                Meteor.users.find _id: $in: @favoriters
    
    
            
# Template.bookmarked_by_list.onCreated ->
#     @autorun => Meteor.subscribe 'bookmarked_by', Template.parentData()._id
    
# Template.bookmarked_by_list.helpers
#     bookmarked_by: ->
#         if @bookmarked_ids
#             if @bookmarked_ids.length > 0
#         # console.log @bookmarked_ids
#                 Meteor.users.find _id: $in: @bookmarked_ids
#         else 
#             false
            
            

    
    
# Template.doc_matches.onCreated ->
#     @is_calculating = new ReactiveVar 'false'
    
# Template.doc_matches.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 500
    
# Template.doc_match.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.ui.accordion').accordion()
#             , 500
    
# Template.doc_matches.helpers
#     # calculate_button_class: ->
#         # if Template.instance().is_calculating then 'loading' else ''
    
# Template.doc_matches.events
#     'click #compute_doc_matches': ->
#         $( "#compute_doc_matches" ).toggleClass( "loading" )
#         # console.log @
#         Meteor.call 'find_top_doc_matches', @_id, (err, res)->
#             $( "#compute_doc_matches" ).toggleClass( "loading" )
#             $( ".title" ).addClass( "active" )
#             $( ".match_content" ).addClass( "active" )
#             # console.log res
            
            
# Template.doc_match.onCreated ->
#     @autorun => Meteor.subscribe 'doc', @data.doc_id
            
# Template.doc_match.helpers
#     match_doc: -> Docs.findOne @doc_id
            
            
            
        
        
Template.parent_doc_accordion.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
# Template.parent_doc_accordion.onCreated ->
#     # console.log @data
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
    
    
Template.parent_doc_segment.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500
    
# Template.parent_doc_segment.onCreated ->
#     # console.log @data
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
    
    
# Template.parent_link.onCreated ->
#     # console.log @data
#     @autorun => Meteor.subscribe 'parent_doc', @data._id
    
Template.parent_link.helpers
    parent: -> Docs.findOne _id: @parent_id
    
    
    
# Template.view_published_toggle.helpers
#     viewing_mine: -> Session.equals 'view_private',true  
#     viewing_all: -> Session.equals 'view_private',false  


# Template.view_published_toggle.events
#     'click #view_my_entries': (e,t)-> Session.set('view_private',true)    
#     'click #view_all_entries': (e,t)-> Session.set('view_private', false)    


# Template.view_read_toggle.helpers
#     viewing_unread: -> Session.equals 'view_unread', true  
#     viewing_all: -> Session.equals 'view_unread',false  


# Template.view_read_toggle.events
#     'click #view_unread': (e,t)-> Session.set('view_unread', true)    
#     'click #view_all': (e,t)-> Session.set('view_unread', false)    



# Template.instance().stripe = Stripe.configure(
#     key: stripe_key
#     image: '/toriwebster-logomark-04.png'
#     locale: 'auto'
#     # zipCode: true
#     token: (token) ->
#         # console.log token
#         purchasing_item = Docs.findOne Session.get 'purchasing_item'
#         console.dir 'purchasing_item', purchasing_item
#         charge = 
#             amount: purchasing_item.price*100
#             currency: 'usd'
#             source: token.id
#             description: token.description
#             receipt_email: token.email
#         Meteor.call 'processPayment', charge, (error, response) =>
#             if error then Bert.alert error.reason, 'danger'
#             else
#                 Meteor.call 'register_transaction', purchasing_item._id, (err, response)->
#                     if err then console.error err
#                     else
#                         Bert.alert "You have purchased #{purchasing_item.title}.", 'success'
#                         Docs.remove Session.get('current_cart_item')
#                         FlowRouter.go "/account"
#     # closed: ->
#     #     Bert.alert "Payment Canceled", 'info', 'growl-top-right'
# )


# Template.icon.helpers
    # 
# Template.response_count.onCreated ->
#     @autorun => Meteor.subscribe 'response_count', @data._id

Template.save_button.events
    'click #toggle_off_editing': -> Session.set 'editing', false
    
    
                
            
Template.edit_child_fields.onCreated ->
    Meteor.subscribe 'fields'
            
Template.edit_child_fields.helpers
    available_child_fields: ->
        Docs.find
            type: 'component'
    
    
    # child_field_toggle_class: ->
    #     doc = Docs.findOne FlowRouter.getParam('doc_id')
    #     if @slug in doc.child_fields then 'blue' else 'basic'



Template.edit_child_fields.events
    'click .toggle_child_field': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.child_field_ids 
            if @_id in doc.child_field_ids
                Docs.update doc._id,
                    $pull: "child_field_ids": @_id
            else
                Docs.update doc._id,
                    $addToSet: "child_field_ids": @_id
        else
            Docs.update doc._id,
                $set: "child_field_ids": []
     


     
Template.edit_child_actions.onCreated ->
    Meteor.subscribe 'actions'
            
Template.edit_child_actions.helpers
    child_actions: ->
        Docs.find
            type: 'action'
    
    
    child_action_toggle_class: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @slug in doc.child_actions then 'blue' else 'basic'



Template.edit_child_actions.events
    'click .toggle_child_action': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.child_actions 
            if @slug in doc.child_actions
                Docs.update doc._id,
                    $pull: "child_actions": @slug
            else
                Docs.update doc._id,
                    $addToSet: "child_actions": @slug
        else
            Docs.update doc._id,
                $set: "child_actions": []
     



     
                
Template.select_template.onCreated ->
    Meteor.subscribe 'templates'
            
Template.select_template.helpers
    templates: ->
        Docs.find
            type: 'template'
    
    child_field_toggle_class: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @slug is doc.template then 'blue' else 'basic'

Template.select_template.events
    'click .select_template': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.template 
            Docs.update doc._id,
                $set: template: @slug
        else
            Docs.update doc._id,
                $set: template: ''
 
 
                
Template.child_authors.onCreated ->
    # console.log @data
    # @autorun => Meteor.subscribe 'usernames'
    @autorun => Meteor.subscribe 'child_docs', @data._id


Template.response_list.onCreated ->
    @autorun => Meteor.subscribe 'child_docs', @data._id

Template.response_list.helpers
    responses: ->
        Docs.find
            parent_id: @_id



Template.user_image_name.onCreated ->
    @autorun => Meteor.subscribe 'person_by_id', @data.user_id

Template.user_image_name.helpers
    user: -> Meteor.users.findOne Template.currentData().user_id
    
Template.user_image.onCreated ->
    @autorun => Meteor.subscribe 'person_by_id', @data.user_id

Template.user_image.helpers
    user: -> Meteor.users.findOne Template.currentData().user_id
    

Template.check_completion_button.events
    'click #check_completion': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log 'completion_type', doc.completion_type
        Meteor.call 'calculate_doc_completion', FlowRouter.getParam('doc_id')