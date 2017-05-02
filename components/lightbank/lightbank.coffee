FlowRouter.route '/lightbank', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'lightbank'

if Meteor.isClient
    # Session.setDefault 'lightbank_view_mode', 'all'
    Template.lightbank.onCreated -> 
        @autorun -> Meteor.subscribe('lightbank', selected_tags.array(), limit=10, lightbank_view_mode=Session.get('lightbank_view_mode'))

    Template.lightbank.helpers
        docs: -> 
            Docs.find {type:'lightbank' }, 
                sort:
                    tag_count: 1
                limit: 10
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

        selected_tags: -> selected_tags.array()

        all_item_class: -> if Session.equals 'lightbank_view_mode', 'all' then 'active' else ''
        mine_item_class: -> if Session.equals 'lightbank_view_mode', 'resonates' then 'active' else ''

    Template.lightbank.events
        'click #set_mode_to_all': -> 
            if Meteor.userId() then Session.set 'lightbank_view_mode', 'all'
            else FlowRouter.go '/sign-in'

        'click #set_mode_to_resonates': -> 
            if Meteor.userId() then Session.set 'lightbank_view_mode', 'resonates'
            else FlowRouter.go '/sign-in'

    
    Template.lightbank_doc_view.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    
        when: -> moment(@timestamp).fromNow()
        
        lightbank_tags: -> _.difference(@tags, 'lightbank')

    Template.lightbank_doc_view.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())



if Meteor.isServer
    Meteor.publish 'lightbank', (selected_tags, limit, lightbank_view_mode)->
    
        self = @
        match = {}
        match.tags = $all: selected_tags
        # if selected_tags.length > 0 then match.tags = $all: selected_tags
        match.type = 'lightbank'
        if lightbank_view_mode is 'resonates'
            match.favoriters = $in: [@userId]
        
        if lightbank_view_mode and lightbank_view_mode is 'mine'
            match.author_id
    
        if limit
            Docs.find match, 
                limit: limit
        else
            Docs.find match



