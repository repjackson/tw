if Meteor.isClient
    FlowRouter.route '/checkin', action: (params) ->
        BlazeLayout.render 'layout',
            # cloud: 'cloud'
            main: 'checkin'
    
    # Session.setDefault 'checkin_view_mode', 'all'
    Template.checkin.onCreated -> 
        @autorun -> Meteor.subscribe('checkin', selected_tags.array(), limit=10, checkin_view_mode=Session.get('checkin_view_mode'))
    
    Template.checkin.helpers
        docs: -> 
            Docs.find {type:'checkin' }, 
                sort:
                    tag_count: 1
                limit: 10
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    
        selected_tags: -> selected_tags.array()
    
        all_item_class: -> if Session.equals 'checkin_view_mode', 'all' then 'active' else ''
        resonates_item_class: -> if Session.equals 'checkin_view_mode', 'resonates' then 'active' else ''
    
    Template.checkin.events
        'click #set_mode_to_all': -> 
            if Meteor.userId() then Session.set 'checkin_view_mode', 'all'
            else FlowRouter.go '/sign-in'
    
        'click #set_mode_to_resonates': -> 
            if Meteor.userId() then Session.set 'checkin_view_mode', 'resonates'
            else FlowRouter.go '/sign-in'
    
    
    Template.checkin_doc_view.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    
        when: -> moment(@timestamp).fromNow()
        
        checkin_tags: -> _.difference(@tags, 'checkin')
    
    Template.checkin_doc_view.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())


if Meteor.isServer
    Meteor.publish 'checkin', (selected_tags, limit, checkin_view_mode)->
    
        self = @
        match = {}
        # match.tags = $all: selected_tags
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.type = 'checkin'
        if checkin_view_mode is 'resonates'
            match.favoriters = $in: [@userId]
        
        if checkin_view_mode and checkin_view_mode is 'mine'
            match.author_id
    
        if limit
            Docs.find match, 
                limit: limit
        else
            Docs.find match
    
    Meteor.publish 'checkin_tags', (selected_tags, limit, checkin_view_mode)->
        
        self = @
        match = {}
        
        match.type = 'checkin'
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        
        if checkin_view_mode is 'resonates'
            match.favoriters = $in: [@userId]
        
        
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
