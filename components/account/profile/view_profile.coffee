FlowRouter.route '/profile/:username', 
    name: 'view_profile'
    action: (params) ->
        BlazeLayout.render 'layout',
            # sub_nav: 'account_nav'
            # sub_nav: 'member_nav'
            main: 'view_profile'





if Meteor.isClient
    Template.view_profile.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))
        
    
    Template.view_profile.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
        
    Template.view_profile.events
