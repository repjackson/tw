if Meteor.isClient
    FlowRouter.route '/admin/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'admin_dashboard'
    
    Template.admin_dashboard.onCreated ->
        
    Template.admin_dashboard.helpers
        
    Template.bug_reports.onCreated ->
        Meteor.subscribe 'bug_reports'
        
    Template.bug_reports.helpers
        bug_reports: ->
            Docs.find
                type: 'bug_report'
        
            
            
if Meteor.isServer
    Meteor.publish 'bug_reports', ->
        Docs.find
            type: 'bug_report'