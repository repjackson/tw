Meteor.publish null, ->
    if @userId
        return Meteor.users.find({ _id: @userId }, fields:
            biography: 1
            followingIds: 1)
    return
Meteor.publish 'userStatus', ->
    Meteor.users.find 'status.online': true
Meteor.publishComposite 'posts.all', (query, filter, limit) ->
    check query, String
    check filter, String
    check limit, Number
    if @userId
        currentUser = Meteor.users.findOne(_id: @userId)
        parameters = 
            find: {}
            options: {}
        if filter == 'following'
            if currentUser.followingIds and currentUser.followingIds.length != 0
                parameters.find.authorId = $in: currentUser.followingIds
            else
                parameters.find.authorId = $in: []
        {
            find: ->
                if query
                    parameters.find.$text = $search: query
                    parameters.options =
                        fields: score: $meta: 'textScore'
                        sort: score: $meta: 'textScore'
                        limit: limit
                else
                    parameters.options =
                        sort: createdAt: -1
                        limit: limit
                Counts.publish this, 'posts.all', Posts.find(parameters.find), noReady: true
                Posts.find parameters.find, parameters.options
            children: [ { find: (post) ->
                Meteor.users.find { _id: post.authorId }, fields:
                    emails: 1
                    username: 1
 } ]
        }
    else
        []
Meteor.publishComposite 'users.profile', (_id, limit) ->
    check _id, String
    check limit, Number
    if @userId
        {
            find: ->
                Meteor.users.find _id: _id
            children: [ { find: (user) ->
                Counts.publish this, 'users.profile', Posts.find(authorId: user._id), noReady: true
                Posts.find { authorId: user._id },
                    sort: createdAt: -1
                    limit: limit
 } ]
        }
    else
        []
Meteor.publish 'users.all', (query, limit) ->
    check query, String
    check limit, Number
    if @userId
        if query
            Counts.publish this, 'users.all', Meteor.users.find($text: $search: query), noReady: true
            Meteor.users.find { $text: $search: query },
                fields: score: $meta: 'textScore'
                sort: score: $meta: 'textScore'
                limit: limit
        else
            Counts.publish this, 'users.all', Meteor.users.find(), noReady: true
            Meteor.users.find {},
                sort: createdAt: -1
                limit: limit
    else
        []
Meteor.publish 'users.following', ->
    if @userId
        currentUser = Meteor.users.findOne(_id: @userId)
        if currentUser.followingIds and currentUser.followingIds.length != 0
            Meteor.users.find { _id: $in: currentUser.followingIds }, sort: username: 1
        else
            []
    else
        []
Meteor.publish 'users.follower', ->
    if @userId
        currentUser = Meteor.users.findOne(_id: @userId)
        Meteor.users.find { followingIds: $in: [ currentUser._id ] }, sort: username: 1
    else
        []
Meteor.publish 'messages.all', ->
    if @userId
        currentUser = Meteor.users.findOne(_id: @userId)
        Messages.find $or: [
            { originatingFromId: currentUser._id }
            { originatingToId: currentUser._id }
        ]
    else
        []
Meteor.publish 'jobs.all', (query, limit) ->
    check query, String
    check limit, Number
    if @userId
        if query
            Counts.publish this, 'jobs.all', Jobs.find(title:
                $regex: '.*' + query + '.*'
                $options: 'i'), noReady: true
            Jobs.find { title:
                $regex: '.*' + query + '.*'
                $options: 'i' },
                sort: createdOn: -1
                limit: limit
        else
            Counts.publish this, 'jobs.all', Jobs.find({}), noReady: true
            Jobs.find {},
                sort: createdOn: -1
                limit: limit
    else
        []
