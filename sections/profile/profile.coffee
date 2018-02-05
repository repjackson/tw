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
                main: 'profile_layout'
                
    FlowRouter.route '/user/:username/comparison', 
        name: 'profile_home'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                user_main: 'profile_comparison'
                
    FlowRouter.route '/user/:username/conversations', 
        name: 'profile_home'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                user_main: 'profile_conversations'
                


    Template.profile_layout.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))
        @autorun -> Meteor.subscribe('ancestor_id_docs', null, FlowRouter.getParam('username'))
        @autorun -> Meteor.subscribe('ancestor_ids', null, FlowRouter.getParam('username'))

        
    # Template.profile_layout.onRendered ->
    #     Meteor.setTimeout =>
    #         $('.menu .item').tab()
    #     , 1000

    
    
    Template.profile_layout.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username')
        
        user_docs: ->
            person = Meteor.users.findOne username:FlowRouter.getParam('username')
            Docs.find
                author_id:person._id
        
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
    Template.profile_layout.events
        'click #logout': -> AccountsTemplates.logout()
