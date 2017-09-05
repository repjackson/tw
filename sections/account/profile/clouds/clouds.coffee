
if Meteor.isClient
    Template.upvoted_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'upvoted_cloud', FlowRouter.getParam('username')



if Meteor.isServer
    Meteor.publish 'upvoted_cloud', ->
        user = Meteor.users.findOne username: FlowRouter.getParam('username')
        Meteor.users.find user._id,
            fields:
                upvoted_cloud: 1
                upvoted_list: 1


if Meteor.isClient
    Template.authored_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'authored_cloud', FlowRouter.getParam('username')



if Meteor.isServer
    Meteor.publish 'authored_cloud', ->
        user = Meteor.users.findOne username: FlowRouter.getParam('username')
        Meteor.users.find user._id,
            fields:
                authored_cloud: 1
                authored_list: 1
                
    Meteor.methods
        generate_authored_cloud: ->
            authored_cloud = Docs.aggregate [
                { $match: author_id: Meteor.userId() }
                { $project: tags: 1 }
                { $unwind: '$tags' }
                { $group: _id: '$tags', count: $sum: 1 }
                { $sort: count: -1, _id: 1 }
                { $limit: 100 }
                { $project: _id: 0, name: '$_id', count: 1 }
                ]
            authored_list = (tag.name for tag in authored_cloud)
            Meteor.users.update Meteor.userId(),
                $set:
                    authored_cloud: authored_cloud
                    authored_list: authored_list


if Meteor.isClient
    Template.downvoted_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'downvoted_cloud', FlowRouter.getParam('username')


if Meteor.isServer
    Meteor.publish 'downvoted_cloud', (username)->
        user = Meteor.users.findOne username: username
        Meteor.users.find user._id,
            fields:
                downvoted_cloud: 1
                downvoted_list: 1
