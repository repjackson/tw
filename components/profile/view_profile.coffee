FlowRouter.route '/profile/:user_id', action: (params) ->
    BlazeLayout.render 'layout',
        # sub_nav: 'account_nav'
        main: 'view_profile'





if Meteor.isClient
    Template.view_profile.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('user_id'))
        
    
    Template.view_profile.helpers
        person: -> 
            Meteor.users.findOne FlowRouter.getParam('user_id') 
        
        is_user: ->
            FlowRouter.getParam('user_id') is Meteor.userId()
        
    Template.view_profile.events
