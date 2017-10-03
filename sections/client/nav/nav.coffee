    
Template.layout.events
    'click #logout': -> AccountsTemplates.logout()

Template.body.events
    'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')
    
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'cart'
    # @autorun -> Meteor.subscribe 'unread_messages'
    # @autorun -> Meteor.subscribe 'all_notifications'
    # @autorun -> Meteor.subscribe 'doc', Session.get 'new_checkin_doc_id'
    @autorun -> Meteor.subscribe 'unread_lightbank_count'
    @autorun -> Meteor.subscribe 'unread_journal_count'

    
    
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

    unread_message_count: ->
        count = 0
        my_conversations = Docs.find(
            type: 'conversation'
            participant_ids: $in: [Meteor.userId()]
        ).fetch()
        
        for conversation in my_conversations
            unread_count = Docs.find(
                type: 'message'
                group_id: conversation._id
                read_by: $nin: [Meteor.userId()]
            ).count()
            count += unread_count
        count


    unread_lightbank_count: -> Counts.get('unread_lightbank_count')
    unread_journal_count: -> Counts.get('unread_journal_count')

        
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
    
    'click #toggle_off_admin_mode': ->Session.set 'admin_mode', false
    'click #toggle_on_admin_mode': ->Session.set 'admin_mode', true
    
    'click #check_in': ->
        new_checkin_doc_id = Docs.insert type: 'checkin'
        FlowRouter.go("/edit/#{new_checkin_doc_id}")
    
    "click #report_bug": ->
        bug_description = prompt "Please decribe the bug:"
        Docs.insert
            type: 'bug_report'
            body: bug_description
            link: window.location.href
    
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal'
        FlowRouter.go("/edit/#{new_journal_id}")
    
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
            
            