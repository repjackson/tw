@Doc_tags = new Meteor.Collection 'doc_tags'

if Meteor.isClient
    
    @selected_doc_tags = new ReactiveArray []

    Template.doc_cloud.onCreated ->
        @autorun -> Meteor.subscribe('doc_tags', selected_doc_tags.array())
    
    Template.doc_cloud.helpers
        doc_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Doc_tags.find { count: $lt: doc_count } else Doc_tags.find({}, limit: 7)
    
        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'big'
                when @index <= 12 then 'large'
                when @index <= 20 then ''
            return button_class
    
        selected_doc_tags: -> selected_doc_tags.array()
    
        settings: -> {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Doc_tags
                    field: 'name'
                    matchAll: false
                    template: Template.tag_result
                }
                ]
        }
    
    
    
    Template.doc_cloud.events
        'click .select_tag': -> selected_doc_tags.push @name
        'click .unselect_tag': -> selected_doc_tags.remove @valueOf()
        'click #clear_tags': -> selected_doc_tags.clear()
    
        'click #add': ->
            Meteor.call 'add', (err,id)->
                FlowRouter.go "/doc/edit/#{id}"

        'keyup #search': (e,t)->
            e.preventDefault()
            val = $('#search').val().toLowerCase().trim()
            switch e.which
                when 13 #enter
                    switch val
                        when 'clear'
                            selected_doc_tags.clear()
                            $('#search').val ''
                        else
                            unless val.length is 0
                                selected_doc_tags.push val.toString()
                                $('#search').val ''
                when 8
                    if val.length is 0
                        selected_doc_tags.pop()
                        
        'autocompleteselect #search': (event, template, doc) ->
            # console.log 'selected ', doc
            selected_doc_tags.push doc.name
            $('#search').val ''


if Meteor.isServer
    Meteor.publish 'doc_tags', (selected_doc_tags)->
        
        self = @
        match = {}
        
        # match.tags = $all: selected_doc_tags

        if selected_doc_tags.length > 0 then match.tags = $all: selected_doc_tags
        
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_doc_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 10 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'doc_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
