Meteor.publish 'facet', (
    selected_theme_tags
    selected_ancestor_ids
    selected_author_ids=[]
    selected_location_tags
    selected_intention_tags
    selected_timestamp_tags
    type
    author_id
    parent_id
    view_private
    )->
    
        self = @
        match = {}
        
        # match.tags = $all: selected_theme_tags
        if type then match.type = type
        if parent_id then match.parent_id = parent_id


        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        if selected_ancestor_ids.length > 0 then match.ancestor_araray = $all: selected_ancestor_ids
        # match.ancestor_araray = $all: selected_ancestor_ids

        if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
        if selected_location_tags.length > 0 then match.location_tags = $all: selected_location_tags
        if selected_intention_tags.length > 0 then match.intention_tags = $all: selected_intention_tags
        if selected_timestamp_tags.length > 0 then match.timestamp_tags = $all: selected_timestamp_tags
        
        if author_id then match.author_id = author_id
        if view_private is true
            match.author_id = Meteor.userId()
        
        if view_private is false
            match.published = $in: [0,1]

        
        
        # console.log 'match:', match
        
        
        ancestor_ids_cloud = Docs.aggregate [
            { $match: match }
            { $project: ancestor_array: 1 }
            { $unwind: "$ancestor_array" }
            { $group: _id: '$ancestor_array', count: $sum: 1 }
            { $match: _id: $nin: selected_ancestor_ids }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'theme ancestor_ids_cloud, ', ancestor_ids_cloud
        ancestor_ids_cloud.forEach (ancestor_id, i) ->
            self.added 'ancestor_ids', Random.id(),
                name: ancestor_id.name
                count: ancestor_id.count
                index: i

        theme_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_theme_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'theme theme_tag_cloud, ', theme_tag_cloud
        theme_tag_cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i



        # watson_keyword_cloud = Docs.aggregate [
        #     { $match: match }
        #     { $project: watson_keywords: 1 }
        #     { $unwind: "$watson_keywords" }
        #     { $group: _id: '$watson_keywords', count: $sum: 1 }
        #     { $match: _id: $nin: selected_theme_tags }
        #     { $sort: count: -1, _id: 1 }
        #     { $limit: 20 }
        #     { $project: _id: 0, name: '$_id', count: 1 }
        #     ]
        # # console.log 'cloud, ', cloud
        # watson_keyword_cloud.forEach (keyword, i) ->
        #     self.added 'watson_keywords', Random.id(),
        #         name: keyword.name
        #         count: keyword.count
        #         index: i

        timestamp_tags_cloud = Docs.aggregate [
            { $match: match }
            { $project: timestamp_tags: 1 }
            { $unwind: "$timestamp_tags" }
            { $group: _id: '$timestamp_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_timestamp_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 10 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention timestamp_tags_cloud, ', timestamp_tags_cloud
        timestamp_tags_cloud.forEach (timestamp_tag, i) ->
            self.added 'timestamp_tags', Random.id(),
                name: timestamp_tag.name
                count: timestamp_tag.count
                index: i
    
    
        intention_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: intention_tags: 1 }
            { $unwind: "$intention_tags" }
            { $group: _id: '$intention_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_intention_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'intention intention_tag_cloud, ', intention_tag_cloud
        intention_tag_cloud.forEach (intention_tag, i) ->
            self.added 'intention_tags', Random.id(),
                name: intention_tag.name
                count: intention_tag.count
                index: i

    
        location_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: location_tags: 1 }
            { $unwind: "$location_tags" }
            { $group: _id: '$location_tags', count: $sum: 1 }
            { $match: _id: $nin: selected_location_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'location location_tag_cloud, ', location_tag_cloud
        location_tag_cloud.forEach (location_tag, i) ->
            self.added 'location_tags', Random.id(),
                name: location_tag.name
                count: location_tag.count
                index: i


        author_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: author_id: 1 }
            { $group: _id: '$author_id', count: $sum: 1 }
            { $match: _id: $nin: selected_author_ids }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, text: '$_id', count: 1 }
            ]
    
    
        # console.log author_tag_cloud
        
        # author_objects = []
        # Meteor.users.find _id: $in: author_tag_cloud.
    
        author_tag_cloud.forEach (author_id) ->
            self.added 'author_ids', Random.id(),
                text: author_id.text
                count: author_id.count

        # found_docs = Docs.find(match).fetch()
        # found_docs.forEach (found_doc) ->
        #     self.added 'docs', doc._id, fields
        #         text: author_id.text
        #         count: author_id.count
        
        # doc_results = []
        subHandle = Docs.find(match, {limit:20, sort: timestamp:-1}).observeChanges(
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
        
        ancestor_doc_ids =  _.pluck ancestor_ids_cloud, 'name'
    
        # if username
        subHandle = Docs.find( {_id:$in:ancestor_doc_ids}, {limit:20, sort: timestamp:-1}).observeChanges(
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

Meteor.publish 'ancestor_id_docs', (ancestor_ids)->
    console.log ancestor_ids
    # Docs.find
    #     _id: $in: ancestor_ids




Meteor.publish 'ancestor_ids', (doc_id, username)->
    match = {}
    self = @
    if doc_id
        # doc = Docs.findOne doc_id
        match._id = doc_id
    if username
        user = Meteor.users.findOne username:username
        match.author_id = user._id
        
    match.ancestor_array = $exists:true    
    # match._id = doc_id
    # console.log match
    # one_child = Docs.findOne(parent_id:doc_id)
    # if one_child
    #     match_array = one_child.ancestor_array
    #     children = Docs.find(parent_id:one_child._id).fetch()
    #     for child in children 
    #         match_array.push child._id
    # else
    #     match_array = doc.ancestor_array
    # match.parent_id = $in:match_array
        
    console.log 'match',match
    # if selected_ancestor_ids.length > 0 then match.ancestor_array = $all: selected_ancestor_ids
    ancestor_ids_cloud = Docs.aggregate [
        { $match: match }
        { $project: ancestor_array: 1 }
        { $unwind: "$ancestor_array" }
        { $group: _id: '$ancestor_array', count: $sum: 1 }
        # { $match: _id: $nin: selected_ancestor_ids }
        { $sort: count: -1, _id: 1 }
        { $limit: 10 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log 'ancestor_ids_cloud, ', ancestor_ids_cloud
    ancestor_ids_cloud.forEach (ancestor_id, i) ->
        self.added 'ancestor_ids', Random.id(),
            name: ancestor_id.name
            count: ancestor_id.count
            index: i

    ancestor_doc_ids =  _.pluck ancestor_ids_cloud, 'name'

    # if username
    subHandle = Docs.find( {_id:$in:ancestor_doc_ids}, {limit:20, sort: timestamp:-1}).observeChanges(
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

    self.ready()
    
    self.onStop ()-> subHandle.stop()


# Meteor.publish 'parent_ids', (username, selected_parent_id)->
#         parent_tag_cloud = Docs.aggregate [
#             { $match: author_id:Meteor.userId() }
#             { $project: parent_id: 1 }
#             # { $unwind: "$tags" }
#             { $group: _id: '$parent_id', count: $sum: 1 }
#             { $match: _id: $nin: selected_theme_tags }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 20 }
#             { $project: _id: 0, name: '$_id', count: 1 }
#             ]
#         # console.log 'theme parent_tag_cloud, ', parent_tag_cloud
#         parent_tag_cloud.forEach (tag, i) ->
#             self.added 'tags', Random.id(),
#                 name: tag.doc_id
#                 count: tag.count
#                 index: i
