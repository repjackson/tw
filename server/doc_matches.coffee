Meteor.methods
    matchTwoDocs: (firstId, secondId)->
        firstDoc = Docs.findOne firstId
        secondDoc = Docs.findOne secondId

        firstTags = firstDoc.tags
        secondTags = secondDoc.tags

        intersection = _.intersection firstTags, secondTags
        intersectionCount = intersection.length

    find_top_doc_matches: (doc_id)->
        this_doc = Docs.findOne doc_id
        tags = this_doc.tags
        match_object = {}
        for tag in tags
            id_array_with_tag = []
            Docs.find({ tags: $in: [tag] }, { tags: 1 }).forEach (doc)->
                if doc._id isnt doc_id
                    id_array_with_tag.push doc._id
            match_object[tag] = id_array_with_tag
        arrays = _.values match_object
        flattened_arrays = _.flatten arrays
        count_object = {}
        for id in flattened_arrays
            if count_object[id]? then count_object[id]++ else count_object[id]=1
        # console.log count_object
        result = []
        for id, count of count_object
            compared_doc = Docs.findOne(id)
            returned_object = {}
            returned_object.doc_id = id
            returned_object.tags = compared_doc.tags
            returned_object.username = compared_doc.username
            returned_object.intersection_tags = _.intersection tags, compared_doc.tags
            returned_object.intersection_tags_count = returned_object.intersection_tags.length
            result.push returned_object

        result = _.sortBy(result, 'intersection_tags_count').reverse()
        result = result[0..5]
        Docs.update doc_id,
            $set: top_doc_matches: result

        # console.log result
        return result

    match_two_users_authored_cloud: (user_id)->
        username = Meteor.users.findOne(user_id).username
        match = {}
        match.authorId = $in: [Meteor.userId(), user_id]

        user_match_authored_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 50 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # authoredList = (tag.name for tag in user_match_authored_cloud)
        Meteor.users.update Meteor.userId(),
            $addToSet:
                authored_cloud_matches:
                    user_id: user_id
                    username: username
                    user_match_authored_cloud: user_match_authored_cloud


    match_two_users_upvoted_cloud: (user_id)->
        username = Meteor.users.findOne(user_id).username
        match = {}
        match.upvoters = $in: [Meteor.userId(), user_id]

        user_match_upvoted_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 50 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        Meteor.users.update Meteor.userId(),
            $addToSet:
                upVotedCloudMatches:
                    user_id: user_id
                    username: username
                    user_match_upvoted_cloud: user_match_upvoted_cloud
