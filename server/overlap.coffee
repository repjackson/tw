Meteor.publish 'overlap', (
    selected_overlap_tags
    other_username
    type
    )->
    
        other_user = Meteor.users.findOne username: other_username

        # Meteor.call 'generate_journal_cloud', other_user._id
        # Meteor.call 'generate_journal_cloud', Meteor.userId()
        
        # if type is 'checkin'
        #     my_cloud = Meteor.user().checkin_cloud
        #     other_cloud = other_user.checkin_cloud
    
        #     my_list = Meteor.user().checkin_list
        #     other_list = other_user.checkin_list
        # else if type is 'journal'
        #     my_cloud = Meteor.user().journal_cloud
        #     other_cloud = other_user.journal_cloud
    
        #     my_list = Meteor.user().journal_list
        #     other_list = other_user.journal_list

        self = @
        
        target_match = {}
        
        if selected_overlap_tags.length > 0 then target_match.tags = $all: selected_overlap_tags
        target_match.author_id = other_user._id
        
        target_match.type = type
        target_match.published = 1
        
        # console.log 'overlap match', match
        target_tag_cloud = Docs.aggregate [
            { $match: target_match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_overlap_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 100 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        
        target_tag_list = _.pluck(target_tag_cloud, 'name')




        my_match = {}
        
        if selected_overlap_tags.length > 0 then my_match.tags = $all: selected_overlap_tags
        my_match.author_id = Meteor.userId()
        my_match.published = 1

        my_match.type = type

        my_tag_cloud = Docs.aggregate [
            { $match: my_match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_overlap_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 100 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
            
        my_tag_list = _.pluck(my_tag_cloud, 'name')




        intersection = _.intersection(my_tag_list, target_tag_list)
        # console.log intersection

        result = []

        for term in intersection
            other_count = _.findWhere(target_tag_cloud, {name: term})
            my_count = _.findWhere(my_tag_cloud, {name: term})
    
            # console.log other_count
            # console.log my_count
            
            term_summed_count = {}
            term_summed_count.name = term
            term_summed_count.count = other_count.count + my_count.count
            result.push term_summed_count


        result.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i


        doc_match = {}
        doc_match.author_id = $in: [other_user._id, Meteor.userId()]
        if selected_overlap_tags.length > 0 then doc_match.tags = $all: selected_overlap_tags
        doc_match.type = type
        doc_match.published = 1

        subHandle = Docs.find(doc_match, {limit:20, sort: timestamp:-1}).observeChanges(
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
        
        # self.onStop ()-> subHandle.stop()
