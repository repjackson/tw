@Herd_tags= new Meteor.Collection 'herd_tags'




if Meteor.isClient
    @selected_herd_tags = new ReactiveArray []
    
    Template.herd_cloud.onCreated ->
        @autorun -> Meteor.subscribe 'herd_tags', selected_herd_tags.array()
    
    
    Template.herd_cloud.helpers
        herd_tags: ->
            herd_count = Herds.find().count()
            if 0 < herd_count < 3 then Herd_tags.find { count: $lt: herd_count } else Herd_tags.find()

            # herd_tags.find()

        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'large'
                when @index <= 12 then ''
                when @index <= 20 then 'small'
            return button_class
    
        selected_herd_tags: -> selected_herd_tags.list()
    
        settings: -> {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Herd_tags
                    field: 'name'
                    matchAll: true
                    template: Template.tag_result
                }
                ]
        }

    
    
    Template.herd_cloud.events
        'click .select_tag': -> selected_herd_tags.push @name
        'click .unselect_tag': -> selected_herd_tags.remove @valueOf()
        'click #clear_tags': -> selected_herd_tags.clear()
    
        'keyup #search': (e,t)->
            e.preventDefault()
            val = $('#search').val().toLowerCase().trim()
            switch e.which
                when 13 #enter
                    switch val
                        when 'clear'
                            selected_herd_tags.clear()
                            $('#search').val ''
                        else
                            unless val.length is 0
                                selected_herd_tags.push val.toString()
                                $('#search').val ''
                when 8
                    if val.length is 0
                        selected_herd_tags.pop()
                        
        'autocompleteselect #search': (event, template, doc) ->
            # console.log 'selected ', doc
            selected_herd_tags.push doc.name
            $('#search').val ''


if Meteor.isServer
    Meteor.publish 'herd_tags', (selected_herd_tags)->
        self = @
        match = {}
        if selected_herd_tags.length > 0 then match.tags = $all: selected_herd_tags

    
        cloud = Herds.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_herd_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'herd_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
    
    
