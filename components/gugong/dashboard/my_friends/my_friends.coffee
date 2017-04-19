if Meteor.isClient
    Template.my_friends.onCreated ->
        @autorun => Meteor.subscribe 'my_friends'
        
    Template.my_friends.helpers
        my_friends: ->
            if Meteor.user() and Meteor.user().friends
                friends_array = []
                for friend_id in Meteor.user()?.friends
                    friend = Meteor.users.findOne friend_id
                    friends_array.push friend
                friends_array
            
            
if Meteor.isServer
    Meteor.publish 'my_friends', ->
        me = Meteor.users.findOne @userId
        Meteor.users.find {_id: $in: me.friends}
            # fields: 
            #     tags: 1
            #     courses: 1
            #     friends: 1
            #     points: 1
            #     status: 1
            #     profile: 1
