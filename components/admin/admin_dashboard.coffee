if Meteor.isClient
    FlowRouter.route '/admin/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'admin_dashboard'
    
    
    Template.admin_dashboard.events
        'click #lightbank': ->
            Session.set 'lighbank_view_mode', 'resonates'
            FlowRouter.go '/lightbank'
            
        'click #courses': ->
            Session.set 'view_mode', 'mine'
            FlowRouter.go '/courses'
            
        'click #lightbank': ->
            Session.set 'lighbank_view_mode', 'resonates'
            FlowRouter.go '/lightbank'
            
        'click #lightbank': ->
            Session.set 'lighbank_view_mode', 'resonates'
            FlowRouter.go '/lightbank'
            
            
            