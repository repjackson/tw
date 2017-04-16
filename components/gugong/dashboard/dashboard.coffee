if Meteor.isClient
    FlowRouter.route '/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'gugong_nav'
            main: 'member_dashboard'
            
    Template.friends_card.onCreated ->
        @autorun -> Meteor.subscribe('my_friends')
            
            
    Template.friends_card.helpers
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
        Meteor.users.find
            _id: $in: me.friends
            