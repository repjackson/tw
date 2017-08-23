if Meteor.isClient
    Template.public_journal.onCreated -> 
        @autorun -> Meteor.subscribe('public_journal', FlowRouter.getParam('username'))


    Template.public_journal.helpers
        public_journal_entries: -> 
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Docs.find
                type: 'journal'
                published: true
                author_id: user._id
    
    
if Meteor.isServer
    Meteor.publish 'public_journal', (username)->
        user = Meteor.users.findOne username: username
        Docs.find
            type: 'journal'
            author_id: Meteor.userId()
            published: true