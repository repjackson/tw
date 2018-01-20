if Meteor.isClient
    
    FlowRouter.route '/profile/:username/journal', 
        name: 'profile_journal'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                # sub_nav: 'member_nav'
                profile_content: 'profile_journal'
    
    
    
    Template.profile_journal.onCreated -> 
        @autorun => Meteor.subscribe('public_journal', FlowRouter.getParam('username'), selected_theme_tags.array())


    Template.profile_journal.helpers
        user: -> Meteor.users.findOne username: FlowRouter.getParam('username')
    
        public_journal_entries: -> 
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Docs.find {
                type: 'journal'
                published: 1
                author_id: user._id
                }, timestamp: -1
    
if Meteor.isServer
    Meteor.publish 'public_journal', (username, selected_theme_tags)->
        # console.log selected_theme_tags
        user = Meteor.users.findOne username: username
        Docs.find {
            type: 'journal'
            author_id: Meteor.userId()
            published: 1
            # tags: $in: selected_theme_tags
            }, sort: timestamp: -1