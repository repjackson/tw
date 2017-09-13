if Meteor.isClient
    FlowRouter.route '/admin/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'admin_dashboard'
    
    Template.admin_dashboard.onCreated ->
        @autorun => Meteor.subscribe 'all_feedback_requests'
        
    Template.feedback_request.onCreated ->
        # console.log @data
        @autorun => Meteor.subscribe 'doc', @data._id
        
        
    Template.admin_dashboard.helpers
        feedback_requests: ->
            Docs.find
                type: 'tori_feedback_request'
            
            
if Meteor.isServer
    publishComposite 'all_feedback_requests',->
        {
            find: ->
                Docs.find
                    type: 'tori_feedback_request'
            children: [
                {
                    find: (request)->
                        Meteor.users.find
                            _id: request.author_id
                }
                {
                    find: (request)->
                        Docs.find
                            _id: request.parent_id
                }
            ]
        }
        
        