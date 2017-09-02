
if Meteor.isClient
    Template.profile_feed.onCreated ->
        @autorun -> Meteor.subscribe 'profile_feed', FlowRouter.getParam('username')

    Template.profile_feed.helpers 
        feed_items: ->
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Notifications.find {
                $or: [
                    { subject_id: user._id }
                    { object_id: user._id }
                ]
            }, limit: 10

    Template.profile_feed.events


if Meteor.isServer
    Meteor.publish 'profile_feed', (username)->
        user = Meteor.users.findOne username: username
        Notifications.find {
            $or: [
                { subject_id: user._id }
                { object_id: user._id }
            ]
        }, limit: 10
