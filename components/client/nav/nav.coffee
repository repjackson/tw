Template.nav.events
    'click #logout': -> AccountsTemplates.logout()
Template.layout.events
    'click #logout': -> AccountsTemplates.logout()

Template.body.events
    'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')
    
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'cart'
    
# Template.nav.onRendered ->
#     Meteor.setTimeout =>
#         $('.ui.dropdown').dropdown()
#     , 500


Template.nav.helpers
    cart_items: -> Docs.find({type: 'cart_item'},{author_id: Meteor.userId()}).count()

