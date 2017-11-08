$.cloudinary.config
    cloud_name:"facet"

Session.setDefault 'editing', false
Session.setDefault 'page_editing', false
Session.setDefault 'inline_editing', false


Session.setDefault 'admin_mode', false
    
    
    
    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is FlowRouter.getParam('username')

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'admin_mode', () ->  Session.get 'admin_mode'


Template.registerHelper 'editing', () -> 
    Session.get('page_editing') or Session.equals('inline_editing', @_id)

Template.registerHelper 'page_editing', () -> Session.get('page_editing')
    
Template.registerHelper 'inline_editing', () -> Session.equals('inline_editing', @_id)


Template.registerHelper 'is_admin', () ->  
    Roles.userIsInRole(Meteor.userId(), 'admin') and Session.equals 'admin_mode', true

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()

Template.registerHelper 'theme_tag_class': -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
Template.registerHelper 'location_tag_class': -> if @valueOf() in selected_location_tags.array() then 'teal' else 'basic'
Template.registerHelper 'intention_tag_class': -> if @valueOf() in selected_intention_tags.array() then 'teal' else 'basic'

Template.registerHelper 'segment_class', () -> 
    if Roles.userIsInRole 'admin'
        if @published is 1 then 'raised blue' else ''
    else
        ''

Template.registerHelper 'read_segment_class', () -> if @read_by and Meteor.userId() in @read_by then 'raised green' else 'basic'

Template.registerHelper 'from_now', () -> moment(@timestamp).fromNow()

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")
# Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")


Template.registerHelper 'tag_class', ()-> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'




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
