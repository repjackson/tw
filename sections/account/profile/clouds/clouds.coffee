if Meteor.isClient
    Template.profile_clouds.onCreated ->
        @autorun -> Meteor.subscribe 'user_clouds', FlowRouter.getParam('username')
    Template.profile_clouds.helpers
        current_user: -> Meteor.users.findOne username: FlowRouter.getParam('username')
    


if Meteor.isServer
    Meteor.publish 'user_clouds', (username)->
        user = Meteor.users.findOne username: username
        Meteor.users.find user._id,
            fields:
                upvoted_cloud: 1
                upvoted_list: 1
                authored_cloud: 1
                authored_list: 1
                downvoted_cloud: 1
                downvoted_list: 1


                
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
    Template.upvoted_matches.helpers
        current_user: -> Meteor.users.findOne username: FlowRouter.getParam('username')

        upvoted_match_list: ->
            my_upvoted_list = Meteor.user().upvoted_list
            other_user = Meteor.users.findOne username: FlowRouter.getParam('username')
            other_upvoted_list = other_user.upvoted_list
            intersection = _.intersection(my_upvoted_list, other_upvoted_list)
            return intersection
    
        upvoted_match_cloud: ->
            my_upvoted_cloud = Meteor.user().upvoted_cloud
            my_upvoted_list = Meteor.user().upvoted_list
            # console.log 'my_upvoted_cloud', my_upvoted_cloud
            other_user = Meteor.users.findOne username: FlowRouter.getParam('username')
            other_upvoted_cloud = other_user.upvoted_cloud
            other_upvoted_list = other_user.upvoted_list
            # console.log 'otherCloud', other_upvoted_cloud
            intersection = _.intersection(my_upvoted_list, other_upvoted_list)
            intersection_cloud = []
            total_count = 0
            for tag in intersection
                my_tag_object = _.findWhere my_upvoted_cloud, name: tag
                his_tag_object = _.findWhere other_upvoted_cloud, name: tag
                # console.log his_tag_object.count
                min = Math.min(my_tag_object.count, his_tag_object.count)
                total_count += min
                intersection_cloud.push
                    tag: tag
                    min: min
            sorted_cloud = _.sortBy(intersection_cloud, 'min').reverse()
            result = {}
            result.cloud = sorted_cloud
            result.total_count = total_count
            return result


    Template.upvoted_matches.events
        'click .match_two_users_upvoted_cloud': ->
            Meteor.call 'match_two_users_upvoted_cloud', @_id, ->
