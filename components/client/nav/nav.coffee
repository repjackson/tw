Template.nav.events
    'click #logout': -> AccountsTemplates.logout()
Template.layout.events
    'click #logout': -> AccountsTemplates.logout()

Template.body.events
    'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')
    
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'cart'
    @autorun -> Meteor.subscribe 'unread_messages'
    @autorun -> Meteor.subscribe 'unread_notifications'
    @autorun -> Meteor.subscribe 'my_bookmarks'
    
    
Template.nav.onRendered ->
    Meteor.setTimeout =>
        $('.ui.dropdown').dropdown()
    , 500
    Meteor.setTimeout =>
        $('.item').popup
            position : 'left center'
    , 500


Template.nav.helpers
    cart_items: -> Docs.find({type: 'cart_item'},{author_id: Meteor.userId()}).count()

    unread_message_count: ->
        Messages.find(
            recipient_id: Meteor.userId()
            read: false
        ).count()
        
    bookmark_docs: -> 
        Docs.find
            bookmarked_ids: $in: [Meteor.userId()]

    unread_notifications_count: ->
        Notifications.find(
            recipient_id: Meteor.userId()
            read: false
            ).count()

    
Template.left_sidebar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context.example .ui.sidebar')
                    .sidebar({
                        context: $('.context.example .bottom.segment')
                        dimPage: false
                        transition:  'push'
                    })
                    .sidebar('attach events', '.context.example .menu .toggle_sidebar.item')
            , 500
            
# Template.right_sidebar.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.context.example .ui.sidebar')
#                     .sidebar({
#                         context: $('.context.example .bottom.segment')
#                         dimPage: false
#                         transition:  'overlay'
#                     })
#                     .sidebar('attach events', '.context.example .menu .toggle_sidebar.item')
#                     ;
#             , 500
            
            