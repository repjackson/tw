if Meteor.isClient
    FlowRouter.route '/facet', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'facet'

    @selected_facet_tags = new ReactiveArray []

    Template.facet.onCreated ->
        @autorun => Meteor.subscribe('facet_tags', selected_facet_tags.array(), limit=20)
        @autorun -> Meteor.subscribe('facet_docs', selected_facet_tags.array())
        Meteor.subscribe('facet_docs', 
            selected_facet_tags.array(), 
            limit=null, 
            view_unvoted=Session.get('view_unvoted'), 
            view_voted_up=Session.get('view_voted_up'), 
            view_voted_down=Session.get('view_voted_down'), 
            )
        @autorun -> Meteor.subscribe 'unvoted_facet_count'
        @autorun -> Meteor.subscribe 'voted_up_facet_count'
        @autorun -> Meteor.subscribe 'voted_down_facet_count'



    Template.facet.helpers
            
        facet_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3
                Tags.find { 
                    count: $lt: doc_count
                    }, limit:10
            else
                Tags.find({}, limit:10)
        
        facet_tag_class: -> 
            button_class = []
            if @valueOf() in selected_facet_tags.array() then button_class.push 'teal' else button_class.push 'basic'

            button_class
    
        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'large'
                when @index <= 12 then ''
                when @index <= 20 then 'small'
            return button_class

        selected_facet_tags: -> selected_facet_tags.array()
    
        settings: -> {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Tags
                    field: 'name'
                    matchAll: false
                    template: Template.tag_result
                }
                ]
        }
    
        facet_docs: -> 
            if Session.get 'editing_id'
                Docs.find Session.get('editing_id')
            else
                Docs.find {type: 'facet' }, 
                    sort:
                        tag_count: 1
            # Docs.find {}, 


        one_doc: -> Docs.find().count() is 1
    
        tag_class: -> if @valueOf() in selected_facet_tags.array() then 'teal' else 'basic'

        selected_facet_tags: -> selected_facet_tags.array()

    
    Template.facet.events
        'click .select_tag': -> selected_facet_tags.push @name
        'click .unselect_tag': -> selected_facet_tags.remove @valueOf()
        'click #clear_tags': -> selected_facet_tags.clear()
    
        'click #add_facet_doc': ->
            new_id = Docs.insert 
                type:'facet'
                tags: selected_facet_tags.array()
            Session.set 'editing_id', new_id

        'keyup #search': (e,t)->
            e.preventDefault()
            val = $('#search').val().toLowerCase().trim()
            switch e.which
                when 13 #enter
                    switch val
                        when 'clear'
                            selected_facet_tags.clear()
                            $('#search').val ''
                        else
                            unless val.length is 0
                                selected_facet_tags.push val.toString()
                                $('#search').val ''
                when 8
                    if val.length is 0
                        selected_facet_tags.pop()
                        
        'autocompleteselect #search': (event, template, doc) ->
            # console.log 'selected ', doc
            selected_facet_tags.push doc.name
            $('#search').val ''


    Template.facet_doc_view.helpers
        facet_card_class: ->
            if Meteor.userId() in @upvoters then 'green'
            else if Meteor.userId() in @downvoters then 'red'



if Meteor.isServer
    publishComposite 'facet_docs', (selected_facet_tags, limit=null)->
        {
            find: ->
                self = @
                match = {}
                # match.tags = $all: selected_facet_tags
                if selected_facet_tags.length > 0 then match.tags = $all: selected_facet_tags
                match.type = 'facet'
                # console.log view_mode
                
                if limit
                    Docs.find match, 
                        limit: limit
                else
                    Docs.find match
            children: [
                { find: (doc) ->
                    Meteor.users.find 
                        _id: doc.author_id
                    }
                ]    
        }

    Meteor.publish 'facet_tags', (selected_tags, limit, view_mode)->
        
        self = @
        match = {}
        
        # match.tags = $all: selected_tags
        match.type = 'facet'
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        
        # console.log 'limit:', limit
        
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
            