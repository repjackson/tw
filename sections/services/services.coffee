if Meteor.isClient
    FlowRouter.route '/services', action: ->
        BlazeLayout.render 'layout',
            # sub_nav: 'member_nav'
            main: 'services'

    Template.services.onCreated ->
        @autorun ->
            Meteor.subscribe('facet', 
                selected_theme_tags.array()
                selected_author_ids.array()
                selected_location_tags.array()
                selected_intention_tags.array()
                selected_timestamp_tags.array()
                type='service'
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

        Session.set 'layout_view', 'list'
    
    Template.services.helpers
        services: -> 
            Docs.find {type: 'service'},
                sort:
                    publish_date: -1
                limit: 5
                
        is_grid_view: -> Session.equals 'layout_view', 'grid'        
        is_list_view: -> Session.equals 'layout_view', 'list'        
                
        list_layout_button_class: -> if Session.get('layout_view') is 'list' then 'teal' else 'basic'
        grid_layout_button_class: -> if Session.get('layout_view') is 'grid' then 'teal' else 'basic'
                
    Template.services.events
        'click #add_service': ->
            id = Docs.insert
                type: 'service'
            FlowRouter.go "/edit/#{id}"
    
        'click #make_list_layout': -> Session.set 'layout_view', 'list'
        'click #make_grid_layout': -> Session.set 'layout_view', 'grid'
        
    Template.service_item.helpers
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    
    Template.service_item.events
        'click .service_tag': ->
            if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove @valueOf() else selected_theme_tags.push @valueOf()
    
    Template.edit_service.events
        'click #delete_doc': ->
            if confirm 'Delete this Service?'
                Docs.remove @_id
                FlowRouter.go '/services'
    
    
    
if Meteor.isServer
    Meteor.publish 'selected_services', ->
        
        self = @
        match = {}
        match.type = 'service'
        # if not @userId or not Roles.userIsInRole(@userId, ['admin'])
        #     match.published = true
        
    
        Docs.find match
    
    
