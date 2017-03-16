@selected_tags = new ReactiveArray []


$.cloudinary.config
    cloud_name:"facet"

Session.setDefault 'cart_item', null
    
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

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()


Template.registerHelper 'when', () -> moment(@timestamp).fromNow()

Template.registerHelper 'in_course', () -> @_id in Meteor.user().courses


Template.registerHelper 'is_dev', () -> Meteor.isDevelopment
