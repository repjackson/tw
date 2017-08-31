if Meteor.isClient    
    Session.setDefault 'journal_view_mode', 'all'
    # @selected_tags = new ReactiveArray []
    
    
if Meteor.isServer
    Meteor.publish 'journal_tags', (selected_tags, selected_author_ids)->
        
        self = @
        match = {}
        
        match.type = 'journal'
        match.author_id = Meteor.userId()
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids

        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
