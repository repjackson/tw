if Meteor.isClient
    FlowRouter.route '/requests', action: ->
        BlazeLayout.render 'layout',
            # sub_nav: 'member_nav'
            main: 'needs'
    
    Template.need.onCreated ->
        Meteor.subscribe 'author', @data._id
        Meteor.subscribe 'doc', @data._id
        
        
    Template.needs.onCreated ->
        @autorun ->
            Meteor.subscribe('facet', 
                selected_theme_tags.array()
                selected_author_ids.array()
                selected_location_tags.array()
                selected_intention_tags.array()
                selected_timestamp_tags.array()
                type='need'
                author_id=null
                parent_id=null
                tag_limit=20
                doc_limit=Session.get 'doc_limit'
                view_published=Session.get('view_published')
                view_read = null
                view_bookmarked=Session.get('view_bookmarked')
                view_resonates = null
                view_complete = null
                view_images = null
                view_lightbank_type = null
                )

        # Session.set 'layout_view', 'list'
    
    Template.needs.helpers
        needs: -> 
            Docs.find {type: 'need'},
                sort:
                    publish_date: -1
                limit: 5
                
        # is_grid_view: -> Session.equals 'layout_view', 'grid'        
        # is_list_view: -> Session.equals 'layout_view', 'list'        
                
        # list_layout_button_class: -> if Session.get('layout_view') is 'list' then 'teal' else 'basic'
        # grid_layout_button_class: -> if Session.get('layout_view') is 'grid' then 'teal' else 'basic'
                
    Template.needs.events
        'click #add_need': ->
            id = Docs.insert
                type: 'need'
            Session.set 'editing', true
        
            FlowRouter.go "/view/#{id}"
    
        # 'click #make_list_layout': -> Session.set 'layout_view', 'list'
        # 'click #make_grid_layout': -> Session.set 'layout_view', 'grid'
        
    Template.need.helpers
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        one_point: -> @point_price is 1
    
    Template.need.events
        'click .need_tag': ->
            if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove @valueOf() else selected_theme_tags.push @valueOf()
    
    Template.view_need.events
        'click #delete_doc': ->
            if confirm 'Delete this request?'
                Docs.remove @_id
                FlowRouter.go '/requests'
    
    
    
# if Meteor.isServer
#     Meteor.publish 'selected_needs', ->
        
#         self = @
#         match = {}
#         match.type = 'need'
#         # if not @userId or not Roles.userIsInRole(@userId, ['admin'])
#         #     match.published = true
        
    
#         Docs.find match
    
    
