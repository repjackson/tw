# FlowRouter.route '/checkin', action: ->
#     BlazeLayout.render 'layout', 
#         main: 'view_checkins'
    
# Template.view_checkins.onCreated ->
#     @autorun -> Meteor.subscribe 'usernames'
#     @autorun => 
#         Meteor.subscribe('facet', 
#             selected_theme_tags.array()
#             selected_author_ids.array()
#             selected_location_tags.array()
#             selected_intention_tags.array()
#             selected_timestamp_tags.array()
#             type = 'checkin'
#             parent_id = null
#             author_id = null
#             tag_limit = 20
#             doc_limit = 20
#             view_published = 
#                 if Session.equals('admin_mode', true) then true else Session.get('view_published')
#             view_read = null
#             view_bookmarked = null
#             view_resonates = null
#             view_complete = null
#             view_images = null
#             view_lightbank_type = null

#             )

# Template.checkin_card.onCreated ->
#     @autorun -> Meteor.subscribe 'usernames'



# Template.view_checkins.helpers
#     checkins: -> Docs.find {type: 'checkin'}

# Template.checkin_card.helpers
#     theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
#     location_tag_class: -> if @valueOf() in selected_location_tags.array() then 'blue' else 'basic'

# Template.checkin_card.events
#     'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
#     'click .location_tag': -> if @valueOf() in selected_location_tags.array() then selected_location_tags.remove(@valueOf()) else selected_location_tags.push(@valueOf())


            
# Template.view_checkins.events
#     'click #add_checkin': ->
#         id = Docs.insert
#             type: 'checkin'
#         FlowRouter.go "/edit/#{id}"
        
        
# # FlowRouter.route '/checkin/:doc_id/view', action: (params) ->
# #     BlazeLayout.render 'layout',
# #         main: 'view_checkin'

# Template.view_checkin.onCreated ->
#     @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

# Template.view_checkin.helpers
#     checkin: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
# # FlowRouter.route '/checkin/:doc_id/edit', action: (params) ->
# #     BlazeLayout.render 'layout',
# #         main: 'edit_checkin'

# Template.edit_checkin.onCreated ->
#     @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

# Template.edit_checkin.helpers
#     checkin: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
# Template.edit_checkin.events
#     'click #delete_checkin': ->
#         swal {
#             title: 'Delete check in?'
#             # text: 'Confirm delete?'
#             type: 'error'
#             animation: false
#             showCancelButton: true
#             closeOnConfirm: true
#             cancelButtonText: 'Cancel'
#             confirmButtonText: 'Delete'
#             confirmButtonColor: '#da5347'
#         }, ->
#             checkin = Docs.findOne FlowRouter.getParam('doc_id')
#             Docs.remove checkin._id, ->
#                 FlowRouter.go "/checkin"        