# import { FlowRouterTitle } from 'meteor/ostrio:flow-router-title';
$.cloudinary.config
    cloud_name:"facet"

Session.setDefault 'cart_item', null
# Session.setDefault 'doc_limit', 10
Session.setDefault 'view_complete', null
Session.setDefault 'editing_id', null


Session.setDefault 'view_private', false
Session.setDefault 'admin_mode', false
    
# FlowRouter.globals.push({
#   title: Meteor.settings.public.site.short
# });
    
# document.title = Meteor.settings.public.site.short
    
  
    
# Meteor.startup ->
#     stripeKey = Meteor.settings.public.stripe.livePublishableKey
#     Stripe.setPublishableKey stripeKey
    
#     STRIPE =
#         getToken: (domElement, card, callback) ->
#             Stripe.card.createToken card, (status, response) ->
#                 if response.error
#                     Bert.alert response.error.message, 'danger'
#                 else
#                     STRIPE.setToken response.id, domElement, callback
#                 return
#             return
#         setToken: (token, domElement, callback) ->
#             $(domElement).append $('<input type=\'hidden\' name=\'stripeToken\' />').val(token)
#             callback()
#             return

#     return

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is FlowRouter.getParam('username')


Template.registerHelper 'person', ()-> Meteor.users.findOne username:FlowRouter.getParam('username')


Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

# Template.registerHelper 'zen_mode', () -> Session.get 'zen_mode'
Template.registerHelper 'admin_mode', () ->  Session.get 'admin_mode'

# Template.registerHelper 'site_name', () ->  Meteor.settings.public.site.slug

Template.registerHelper 'site_doc', () ->  Docs.findOne type:'site_doc'

Template.registerHelper 'is_editing', () ->  Session.equals 'editing_id', @_id

Template.registerHelper 'is_admin', () ->  
    Roles.userIsInRole(Meteor.userId(), 'admin') and Session.equals 'admin_mode', true

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()

Template.registerHelper 'field_view_template', () ->  
    field_doc = Docs.findOne @valueOf()
    console.log field_doc
    "view_#{field_doc.field_type}_field"

Template.registerHelper 'field_edit_template', () -> 
    console.log @
    console.log @slug
    "edit_#{@}"
        
Template.registerHelper 'field_config_template', () ->  "#{@type}_field_config"

Template.registerHelper 'action_button_template', () ->  "#{@}_button"

        



Template.registerHelper 'theme_tag_class': -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
Template.registerHelper 'location_tag_class': -> if @valueOf() in selected_location_tags.array() then 'teal' else 'basic'
Template.registerHelper 'intention_tag_class': -> if @valueOf() in selected_intention_tags.array() then 'teal' else 'basic'

Template.registerHelper 'segment_class', () -> 
    if Roles.userIsInRole 'admin'
        if @published is 1 then 'raised blue' else ''
    else
        ''
# Template.registerHelper 'card_class', () -> if Session.equals('admin_mode', true) then '' else 'noborders'

Template.registerHelper 'read_segment_class', () -> if @read_by and Meteor.userId() in @read_by then 'raised green' else 'basic'
Template.registerHelper 'published_class', () -> 
    # console.log @published
    switch @published
        when 0 then 'blue'
        when 1 then 'green'
        when -1 then 'red'

Template.registerHelper 'from_now', () -> moment(@timestamp).fromNow()

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")
# Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")


# Template.registerHelper 'in_course', () -> @_id in Meteor.user().courses
# Template.registerHelper 'in_sol', () -> Roles.userIsInRole 'sol_member'
# Template.registerHelper 'in_demo', () -> Roles.userIsInRole 'sol_demo_member'

Template.registerHelper 'tag_class', ()-> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'

# Template.registerHelper 'background_style', () -> "background-image:url('https://res.cloudinary.com/facet/image/upload/c_fit/rczjotzxkirmg4g83axa')"
Template.registerHelper 'background_style', () -> "background-image:url('https://res.cloudinary.com/facet/image/upload/c_fit,w_900/drlclznxvdcaudmelygx')"



# messages
Template.registerHelper 'message_segment_class', -> if @read then '' else 'blue raised'



Template.registerHelper 'is_dev', () -> Meteor.isDevelopment

FlowRouter.wait()
Tracker.autorun ->
  # if the roles subscription is ready, start routing
  # there are specific cases that this reruns, so we also check
  # that FlowRouter hasn't initalized already
  if Roles.subscription.ready() and !FlowRouter._initialized
     FlowRouter.initialize()



Template.staus_indicator.helpers
    labelClass: ->
        if @status?.idle
            'yellow'
        else if @status?.online
            'green'
        else
            'basic'

    online: ->  @status?.online
    
    idle: ->  @status?.idle



Meteor.startup ->
    Status.setTemplate('semantic_ui')
# new FlowRouterTitle(FlowRouter);
