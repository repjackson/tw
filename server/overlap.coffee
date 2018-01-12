Meteor.publish 'overlap', (
    selected_overlap_tags
    other_username
    )->
    
        other_user = Meteor.users.findOne username: other_username

        # Meteor.call 'generate_journal_cloud', other_user._id
        # Meteor.call 'generate_journal_cloud', Meteor.userId()


        my_cloud = Meteor.user().journal_cloud
        other_cloud = other_user.journal_cloud

        my_journal_list = Meteor.user().journal_list
        other_journal_list = other_user.journal_list

        # my_linear_cloud = _.pluck(my_cloud, 'name')
        # other_linear_cloud = _.pluck(other_cloud, 'name')

        intersection = _.intersection(my_journal_list, other_journal_list)
        # console.log intersection

        first_term = intersection[0]
        console.log first_term
    
        # console.log other_cloud.first_term
        # console.log my_cloud.first_term
        other_count = _.findWhere(other_cloud, {name: first_term})
        my_count = _.findWhere(my_cloud, {name: first_term})

        console.log other_count
        console.log my_count
        
        term_summed_count = {}
        term_summed_count.name = first_term
        term_summed_count.count = other_count.count + my_count.count
        console.log term_summed_count
    
        self = @
        match = {}
        
        if selected_overlap_tags.length > 0 then match.tags = $all: selected_overlap_tags
        
        
        
        
        match.author_id = $in: [other_user._id, Meteor.userId()]
        
        match.type = 'journal'
        # console.log 'overlap match', match
        overlap_tag_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_overlap_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'theme overlap_tag_cloud, ', overlap_tag_cloud
        overlap_tag_cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i


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
