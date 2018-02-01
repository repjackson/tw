if Meteor.isClient
    # loggedIn = FlowRouter.group
    #     triggersEnter: [ ->
    #         unless Meteor.loggingIn() or Meteor.userId()
    #             route = FlowRouter.current()
    #             unless route.route.name is 'login'
    #                 Session.set 'redirectAfterLogin', route.path
    #             FlowRouter.go ‘login’
    #     ]
    
    FlowRouter.route '/user/:username', 
        name: 'profile_home'
        action: (params) ->
            BlazeLayout.render 'layout',
                main: 'view_profile'
                


    Template.view_profile.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))

        
    Template.view_profile.onRendered ->
    
    
    
    Template.view_profile.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username')
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
    Template.view_profile.events
        'click #logout': -> AccountsTemplates.logout()
