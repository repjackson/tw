if Meteor.isClient
    FlowRouter.route '/goals', action: ->
        BlazeLayout.render 'layout',
            # sub_nav: 'member_nav'
            main: 'goals'
    
    Template.goal.onCreated ->
        Meteor.subscribe 'author', @data._id
        # Meteor.subscribe 'doc', @data._id
        
        
    Template.goals.onCreated ->
        @autorun ->
            Meteor.subscribe('facet', 
                selected_theme_tags.array()
                selected_author_ids.array()
                selected_location_tags.array()
                selected_intention_tags.array()
                selected_timestamp_tags.array()
                type='goal'
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
    
    Template.goals.helpers
        goals: -> 
            Docs.find {type: 'goal'},
                sort:
                    publish_date: -1
                limit: 5
                
        # is_grid_view: -> Session.equals 'layout_view', 'grid'        
        # is_list_view: -> Session.equals 'layout_view', 'list'        
                
        # list_layout_button_class: -> if Session.get('layout_view') is 'list' then 'teal' else 'basic'
        # grid_layout_button_class: -> if Session.get('layout_view') is 'grid' then 'teal' else 'basic'
                
    Template.goals.events
        'click #add_goal': ->
            id = Docs.insert
                type: 'goal'
            Session.set 'editing', true

            FlowRouter.go "/view/#{id}"
    
        # 'click #make_list_layout': -> Session.set 'layout_view', 'list'
        # 'click #make_grid_layout': -> Session.set 'layout_view', 'grid'
        
    Template.goal.helpers
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        one_point: -> @point_price is 1
    
    Template.goal.events
        'click .goal_tag': ->
            if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove @valueOf() else selected_theme_tags.push @valueOf()
    
    
    
# if Meteor.isServer
#     Meteor.publish 'selected_goals', ->
        
#         self = @
#         match = {}
#         match.type = 'goal'
#         # if not @userId or not Roles.userIsInRole(@userId, ['admin'])
#         #     match.published = true
        
    
#         Docs.find match
    
    
