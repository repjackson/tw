@People_tags = new Meteor.Collection 'people_tags'

if Meteor.isClient
    @selected_people_tags = new ReactiveArray []
    
    Template.people_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'people_tags', selected_people_tags.array()
    
    Template.people_cloud.helpers
        all_people_tags: ->
            user_count = Meteor.users.find(_id: $ne:Meteor.userId()).count()
            if 0 < user_count < 3 then People_tags.find({ count: $lt: user_count }, {limit:20}) else People_tags.find({}, limit:20)
            # People_tags.find()
    
        selected_people_tags: -> selected_people_tags.array()
    
        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'big'
                when @index <= 10 then 'large'
                when @index <= 15 then ''
                when @index <= 20 then 'small'
                when @index <= 25 then 'tiny'
            return button_class


    Template.people_cloud.events
        'click .select_tag': -> selected_people_tags.push @name
        'click .unselect_tag': -> selected_people_tags.remove @valueOf()
        'click #clear_tags': -> selected_people_tags.clear()


if Meteor.isServer
    Meteor.publish 'people_tags', (selected_people_tags)->
        self = @
        match = {}
        if selected_people_tags.length > 0 then match.tags = $all: selected_people_tags
        match._id = $ne: @userId
        # match["profile.published"] = true

        # console.log match

        people_cloud = Meteor.users.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_people_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', people_cloud
        people_cloud.forEach (tag, i) ->
            self.added 'people_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
