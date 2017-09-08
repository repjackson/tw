    
Template.layout.events
    'click #logout': -> AccountsTemplates.logout()

Template.body.events
    'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')
    
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'cart'
    @autorun -> Meteor.subscribe 'unread_messages'
    @autorun -> Meteor.subscribe 'all_notifications'
    # @autorun -> Meteor.subscribe 'doc', Session.get 'new_checkin_doc_id'
    # @autorun -> Meteor.subscribe 'my_bookmarks'

    
    
    
Template.nav.onRendered ->
    # Meteor.setTimeout =>
    #     $('.ui.dropdown').dropdown()
    # , 1000
    Meteor.setTimeout =>
        $('.item').popup
            position : 'left center'
    , 1000


Template.nav.helpers
    cart_items: -> Docs.find({type: 'cart_item'},{author_id: Meteor.userId()}).count()


    # unread_message_count: ->
    #     count = Messages.find(
    #         recipient_id: Meteor.userId()
    #         status: 'sent'
    #         read: false
    #     ).count()
    #     # console.log count
    #     return count
        
    # bookmark_docs: -> 
    #     Docs.find
    #         bookmarked_ids: $in: [Meteor.userId()]

    # unread_notifications_count: ->
    #     Notifications.find(
    #         read_by: $nin: [Meteor.userId()]
    #         ).count()

    # unread_notifications: ->
    #     Notifications.find {},
    #         sort: timestamp: -1
    #         limit: 10

Template.nav.events
# 	'mouseenter .item': (e,t)-> $(e.currentTarget).closest('.icon').toggleClass( "large" )
# 	'mouseleave .item': (e,t)-> $(e.currentTarget).closest('.icon').toggleClass( "large" )

    'click #logout': -> AccountsTemplates.logout()
    
    # 'click #test': ->
    #     Notification.requestPermission()
    
    
    'click #check_in': ->
        new_checkin_doc_id = Docs.insert type: 'checkin'
        FlowRouter.go("/checkin/#{new_checkin_doc_id}/edit")
    
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
            , 1000
            
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
            
            