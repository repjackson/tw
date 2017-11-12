if Meteor.isClient
    FlowRouter.route '/profile/:username', 
        name: 'profile_home'
        action: (params) ->
            BlazeLayout.render 'layout',
                main: 'profile'
                
    
    
    Template.profile.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))

        
    Template.profile.onRendered ->
    
    
    Template.profile.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
        
    Template.profile.events
        'click #logout': -> AccountsTemplates.logout()
