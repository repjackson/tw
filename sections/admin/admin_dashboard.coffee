if Meteor.isClient
    FlowRouter.route '/admin/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'admin_dashboard'
    
    Template.admin_dashboard.onCreated ->
        
    Template.admin_dashboard.helpers
        
    Template.bug_reports.onCreated -> 
        self = @
        @autorun => 
            Meteor.subscribe('facet', 
                selected_theme_tags.array()
                selected_author_ids.array()
                selected_location_tags.array()
                selected_intention_tags.array()
                selected_timestamp_tags.array()
                type='bug_report'
                author_id=null
                parent_id=null
                manual_limit=null
                view_private=null
                view_published=null
                view_unread=null
                view_bookmarked=null
                view_resonates=null
                view_complete=Session.get 'view_complete'
                view_incomplete=Session.get 'view_incomplete'
                )

        
    Template.bug_report.onCreated ->
        Meteor.subscribe 'author', @data._id
        
    Template.bug_reports.helpers
        bug_reports: ->
            Docs.find
                type: 'bug_report'
        
            
            
if Meteor.isServer
    Meteor.publish 'bug_reports', ->
        Docs.find
            type: 'bug_report'