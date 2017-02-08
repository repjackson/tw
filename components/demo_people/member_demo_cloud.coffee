@member_demo_tags= new Meteor.Collection 'member_demo_tags'




if Meteor.isClient
    @selected_member_demo_tags = new ReactiveArray []
    
    Template.member_demo_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'member_demo_tags', selected_member_demo_tags.array()
    
    
    Template.member_demo_cloud.helpers
        member_demo_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then member_demo_tags.find { count: $lt: doc_count } else member_demo_tags.find()

            # member_demo_tags.find()

        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'large'
                when @index <= 12 then ''
                when @index <= 20 then 'small'
            return button_class
    
        selected_member_demo_tags: -> selected_member_demo_tags.list()
    

    
    
    Template.member_demo_cloud.events
        'click .select_tag': -> selected_member_demo_tags.push @name
        'click .unselect_tag': -> selected_member_demo_tags.remove @valueOf()
        'click #clear_tags': -> selected_member_demo_tags.clear()
    


if Meteor.isServer
    Meteor.publish 'member_demo_tags', (selected_member_demo_tags)->
        self = @
        match = {}
        if selected_member_demo_tags.length > 0 then match.tags = $all: selected_member_demo_tags
        match.type = 'demo_member'

    
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_member_demo_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'member_demo_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
    
    
