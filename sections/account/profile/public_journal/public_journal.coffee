if Meteor.isClient
    Template.public_journal.onCreated -> 
        @autorun => Meteor.subscribe('public_journal', FlowRouter.getParam('username'), selected_tags.array())


    Template.public_journal.helpers
        user: -> Meteor.users.findOne username: FlowRouter.getParam('username')
    
        public_journal_entries: -> 
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Docs.find {
                type: 'journal'
                published: true
                author_id: user._id
                }, timestamp: -1
    
if Meteor.isServer
    Meteor.publish 'public_journal', (username, selected_tags)->
        # console.log selected_tags
        user = Meteor.users.findOne username: username
        Docs.find {
            type: 'journal'
            author_id: Meteor.userId()
            published: true
            tags: $in: selected_tags
            }, sort: timestamp: -1