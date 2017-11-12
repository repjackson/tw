Meteor.publish 'facet', (
    selected_theme_tags
    type
    author_id
    parent_id
    tag_limit
    doc_limit
    view_voted
    view_public
    view_published
    editing_id
    )->
    
        self = @
        match = {}
        
        # match.tags = $all: selected_theme_tags
        if type then match.type = type
        if parent_id then match.parent_id = parent_id

        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        
        if tag_limit then limit=tag_limit else limit=50
        if author_id then match.author_id = author_id
        
        if view_voted is 1
            match.upvoters = $in: [Meteor.userId()]
        else if view_voted is 0
            match.upvoters = $nin: [Meteor.userId()]
            match.downvoters = $nin: [Meteor.userId()]
        else if view_voted is -1
            match.downvoters = $in: [Meteor.userId()]
            
            
        if view_public is true
            match.published = $in: [1,0]
        else if Meteor.userId()
            match.author_id = Meteor.userId()
        # else
        #     match.published = $in: [1,0]
            
        if editing_id
            # match._id = $ne: editing_id
            match._id = editing_id
        
        theme_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_theme_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'theme theme_tag_cloud, ', theme_tag_cloud
        theme_tag_cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i

        # doc_results = []
        int_doc_limit = parseInt doc_limit
        subHandle = Docs.find(match, {limit:int_doc_limit, sort: timestamp:-1}).observeChanges(
            added: (id, fields) ->
                # console.log 'added doc', id, fields
                # doc_results.push id
                self.added 'docs', id, fields
            changed: (id, fields) ->
                # console.log 'changed doc', id, fields
                self.changed 'docs', id, fields
            removed: (id) ->
                # console.log 'removed doc', id, fields
                # doc_results.pull id
                self.removed 'docs', id
        )
        
        # for doc_result in doc_results
            
        # user_results = Meteor.users.find(_id:$in:doc_results).observeChanges(
        #     added: (id, fields) ->
        #         # console.log 'added doc', id, fields
        #         self.added 'docs', id, fields
        #     changed: (id, fields) ->
        #         # console.log 'changed doc', id, fields
        #         self.changed 'docs', id, fields
        #     removed: (id) ->
        #         # console.log 'removed doc', id, fields
        #         self.removed 'docs', id
        # )
        
        
        
        # console.log 'doc handle count', subHandle._observeDriver._results

        self.ready()
        
        self.onStop ()-> subHandle.stop()


Meteor.publish 'author', (doc_id)->
    doc = Docs.findOne doc_id
    if doc 
        Meteor.users.find _id: doc.author_id