if Meteor.isClient
    Template.my_tests.onCreated -> 
        @autorun -> Meteor.subscribe('my_tests')


    Template.my_tests.helpers
        my_tests: -> 
            if Meteor.user()?.tests?
                Docs.find
                    _id: $in: Meteor.user().tests
    
        in_test: ->
            Meteor.user()?.my_tests and @title in Meteor.user().my_tests
    
if Meteor.isServer
    Meteor.publish 'my_tests', ->
        me = Meteor.users.findOne @userId
        Docs.find
            type: 'test_session'