Posts.allow
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')






Meteor.publish 'featured_posts', ->
    Posts.find {
        featured: true
        }, sort: publish_date: -1
        

Meteor.publish 'selected_posts', (selected_post_tags)->
    
    self = @
    match = {}
    if selected_post_tags.length > 0 then match.tags = $all: selected_post_tags
    if not @userId or not Roles.userIsInRole(@userId, ['admin'])
        match.published = true
    

    Posts.find match,
        limit: 10
        sort: 
            publish_date: -1


# Meteor.publish 'post_tags', (selected_post_tags)->
#     self = @
#     match = {}
#     if selected_post_tags.length > 0 then match.tags = $all: selected_post_tags
#     if not @userId or not Roles.userIsInRole(@userId, ['admin'])
#         match.published = true
    


#     cloud = Posts.aggregate [
#         { $match: match }
#         { $project: "tags": 1 }
#         { $unwind: "$tags" }
#         { $group: _id: "$tags", count: $sum: 1 }
#         { $match: _id: $nin: selected_post_tags }
#         { $sort: count: -1, _id: 1 }
#         { $limit: 20 }
#         { $project: _id: 0, name: '$_id', count: 1 }
#         ]

#     cloud.forEach (tag, i) ->
#         self.added 'post_tags', Random.id(),
#             name: tag.name
#             count: tag.count
#             index: i

#     self.ready()



Meteor.publish 'post', (post_id)->
    Posts.find post_id

    
