if Meteor.isClient
    FlowRouter.route '/admin/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'admin_dashboard'
    
    Template.admin_dashboard.onCreated ->
        
        
        
    Template.admin_dashboard.helpers
            
            
# if Meteor.isServer
        