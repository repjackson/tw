if Meteor.isClient
    Template.my_public_quiz_sessions.onCreated -> 
        @autorun -> Meteor.subscribe('my_public_quiz_sessions')


    Template.my_public_quiz_sessions.helpers
        my_public_quiz_sessions: -> 
            Docs.find
                type: 'quiz_session'
    
    
if Meteor.isServer
    Meteor.publish 'my_public_quiz_sessions', ->
        me = Meteor.users.findOne @userId
        Docs.find
            type: 'quiz_session'
            author_id: @userId
            published: true