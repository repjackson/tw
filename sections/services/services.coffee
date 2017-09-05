if Meteor.isClient
    FlowRouter.route '/services', action: ->
        BlazeLayout.render 'layout',
            # sub_nav: 'member_nav'
            main: 'services'

    Template.services.onCreated ->
        @autorun -> Meteor.subscribe('selected_services')
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
            FlowRouter.go "/service/edit/#{id}"
    
        'click #make_list_layout': -> Session.set 'layout_view', 'list'
        'click #make_grid_layout': -> Session.set 'layout_view', 'grid'
        
    Template.service_item.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    
        can_edit: -> @author_id is Meteor.userId()
    
    Template.service_item.events
        'click .service_tag': ->
            if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()
    
if Meteor.isServer
    Meteor.publish 'selected_services', ->
        
        self = @
        match = {}
        match.type = 'service'
        # if not @userId or not Roles.userIsInRole(@userId, ['admin'])
        #     match.published = true
        
    
        Docs.find match
    
    
