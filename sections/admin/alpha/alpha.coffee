if Meteor.isClient
    FlowRouter.route '/admin/alpha', action: (params) ->
        BlazeLayout.render 'layout',
            nav: 'nav'
            sub_nav: 'admin_nav'
            main: 'alpha'


    @selected_all_tags = new ReactiveArray []

    Template.alpha.onCreated ->
        @autorun => Meteor.subscribe('all_tags', selected_all_tags.array())
        @autorun -> Meteor.subscribe('all_docs', selected_all_tags.array())
        @autorun -> Meteor.subscribe 'root'
    
    
    Template.alpha_menu.onCreated -> 
        @autorun => 
            if @subscriptionsReady()
                Meteor.subscribe 'doc', @data._id

    Template.alpha.helpers
        root: -> Docs.findOne type: 'root'
        
        child: -> Docs.findOne _id: Session.get('child_id')
        
        view_type_template: -> 
            child = Docs.findOne _id:Session.get('child_id')
            return "view_#{child.type}"
            
            
        all_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3
                Tags.find { 
                    count: $lt: doc_count
                    }, limit:10
            else
                Tags.find({}, limit:10)
        
        all_tag_class: -> 
            button_class = []
            if @valueOf() in selected_all_tags.array() then button_class.push 'teal' else button_class.push 'basic'

            button_class
    
        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'large'
                when @index <= 12 then ''
                when @index <= 20 then 'small'
            return button_class

        selected_all_tags: -> selected_all_tags.array()
    
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
    
        all_docs: -> 
            Docs.find {}, 
                sort:
                    tag_count: 1
            # Docs.find {}, 


        tag_class: -> if @valueOf() in selected_all_tags.array() then 'active' else 'basic'
        selected_all_tags: -> selected_all_tags.array()
    
    
    
    Template.alpha.events
        'click .select_tag': -> selected_all_tags.push @name
        'click .unselect_tag': -> selected_all_tags.remove @valueOf()
        'click #clear_tags': -> selected_all_tags.clear()
    
        'keyup #search': (e,t)->
            e.preventDefault()
            val = $('#search').val().toLowerCase().trim()
            switch e.which
                when 13 #enter
                    switch val
                        when 'clear'
                            selected_all_tags.clear()
                            $('#search').val ''
                        else
                            unless val.length is 0
                                selected_all_tags.push val.toString()
                                $('#search').val ''
                when 8
                    if val.length is 0
                        selected_all_tags.pop()
                        
        'click #add': ->
            id = Docs.insert {}
            FlowRouter.go "/alpha_edit/#{id}"
                        
        'autocompleteselect #search': (event, template, doc) ->
            # console.log 'selected ', doc
            selected_all_tags.push doc.name
            $('#search').val ''

    Template.alpha_menu.events
        'click .create_child': ->
            id = Docs.insert parent_id: @_id
            FlowRouter.go "/alpha_edit/#{id}"
        'click #toggle_off_admin_mode': ->Session.set 'admin_mode', false
        'click #toggle_on_admin_mode': ->Session.set 'admin_mode', true
        'click #check_in': ->
            new_checkin_doc_id = Docs.insert type: 'checkin'
            Session.set 'editing', true
            FlowRouter.go("/view/#{new_checkin_doc_id}")

    Template.alpha_menu.helpers
        children: ->
            Docs.find {parent_id: @_id}, sort: number:1                

        unread_message_count: ->
            count = 0
            my_conversations = Docs.find(
                type: 'conversation'
                participant_ids: $in: [Meteor.userId()]
            ).fetch()
            
            for conversation in my_conversations
                unread_count = Docs.find(
                    type: 'message'
                    group_id: conversation._id
                    read_by: $nin: [Meteor.userId()]
                ).count()
                count += unread_count
            count
    
    
        unread_lightbank_count: -> Counts.get('unread_lightbank_count')
        unread_journal_count: -> Counts.get('unread_journal_count')



    Template.child_menu.helpers
        parent_children: -> 
            parent_id = Template.parentData(0)._id
            # console.log parent_id
            Docs.find {parent_id: parent_id}, sort: number:1





    Template.alpha_menu.events
        'click .select_child': -> 
            Session.set 'child_id', @_id
            


if Meteor.isServer
    Meteor.publish 'root', -> Docs.find type:'root'
    
    publishComposite 'all_docs', (selected_all_tags)->
        {
            find: ->
                self = @
                match = {}
                # match.tags = $all: selected_all_tags
                if selected_all_tags.length > 0 then match.tags = $all: selected_all_tags
                Docs.find match, 
                    limit: 20
            children: [
                { find: (doc) ->
                    Meteor.users.find 
                        _id: doc.author_id
                    }
                { find: (doc) ->
                    Docs.find 
                        _id: doc.parent_id
                    }
                ]    
        }

    Meteor.publish 'all_tags', (selected_theme_tags)->
        
        self = @
        match = {}
        
        # match.tags = $all: selected_theme_tags
        if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
        
        
        cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: "$tags" }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_theme_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', cloud
        cloud.forEach (tag, i) ->
            self.added 'tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
            