@Feature_tags= new Meteor.Collection 'feature_tags'




if Meteor.isClient
    @selected_feature_tags = new ReactiveArray []
    
    Template.feature_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'feature_tags', selected_feature_tags.array()
    
    
    Template.feature_cloud.helpers
        feature_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Feature_tags.find { count: $lt: doc_count } else Feature_tags.find()

            # Feature_tags.find()

        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'large'
                when @index <= 12 then ''
                when @index <= 20 then 'small'
            return button_class
    
        selected_feature_tags: -> selected_feature_tags.list()
    

    
    
    Template.feature_cloud.events
        'click .select_tag': -> selected_feature_tags.push @name
        'click .unselect_tag': -> selected_feature_tags.remove @valueOf()
        'click #clear_tags': -> selected_feature_tags.clear()
    


if Meteor.isServer
    Meteor.publish 'feature_tags', (selected_feature_tags)->
        self = @
        match = {}
        if selected_feature_tags.length > 0 then match.tags = $all: selected_feature_tags
        match.type = 'feature'

    
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_feature_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'feature_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
    
    
