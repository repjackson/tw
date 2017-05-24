$.cloudinary.config
    cloud_name:"facet"

Session.setDefault 'cart_item', null


Session.setDefault 'view_mode', 'all'
    
    
    
    
Meteor.startup ->
    stripeKey = Meteor.settings.public.stripe.livePublishableKey
    Stripe.setPublishableKey stripeKey
    
    STRIPE =
        getToken: (domElement, card, callback) ->
            Stripe.card.createToken card, (status, response) ->
                if response.error
                    Bert.alert response.error.message, 'danger'
                else
                    STRIPE.setToken response.id, domElement, callback
                return
            return
        setToken: (token, domElement, callback) ->
            $(domElement).append $('<input type=\'hidden\' name=\'stripeToken\' />').val(token)
            callback()
            return

    return

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()

        
Template.registerHelper 'segment_class', () -> 
    if Roles.userIsInRole 'admin'
        if @published then 'raised blue' else ''
    else
        ''
Template.registerHelper 'ribbon_class', () -> if @published then 'blue' else 'basic'

Template.registerHelper 'from_now', () -> moment(@timestamp).fromNow()

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")
# Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")


Template.registerHelper 'in_course', () -> @_id in Meteor.user().courses
Template.registerHelper 'in_sol', () -> Roles.userIsInRole 'sol_member'
Template.registerHelper 'in_demo', () -> Roles.userIsInRole 'sol_demo_member'


Template.registerHelper 'is_editing', () -> 
    # console.log 'this', @
    Session.equals 'editing_id', @_id


Template.registerHelper 'is_dev', () -> Meteor.isDevelopment

FlowRouter.wait()
Tracker.autorun ->
  # if the roles subscription is ready, start routing
  # there are specific cases that this reruns, so we also check
  # that FlowRouter hasn't initalized already
  if Roles.subscription.ready() and !FlowRouter._initialized
     FlowRouter.initialize()



# Template.staus_indicator.helpers
#     labelClass: ->
#         if @status?.idle
#             'yellow'
#         else if @status?.online
#             'green'
#         else
#             'basic'

#     online: ->  @status?.online
    
#     idle: ->  @status?.idle


Template.layout.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context.example .ui.sidebar')
                    .sidebar({
                        context: $('.context.example .bottom.segment')
                    })
                    .sidebar('attach events', '.context.example .menu .item')
                    ;
            , 500