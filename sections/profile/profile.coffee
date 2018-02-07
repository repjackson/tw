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
        action: (params) ->
            BlazeLayout.render 'user_layout',
                user_main: 'user_info'
                
    FlowRouter.route '/user/:username/comparison', 
        action: (params) ->
            BlazeLayout.render 'user_layout',
                user_main: 'user_comparison'
                
    FlowRouter.route '/user/:username/conversations', 
        action: (params) ->
            BlazeLayout.render 'user_layout',
                user_main: 'user_conversations'
                
    FlowRouter.route '/user/:username/documents', 
        action: (params) ->
            BlazeLayout.render 'user_layout',
                user_main: 'user_documents'
                
    FlowRouter.route '/user/:username/contact', 
        action: (params) ->
            BlazeLayout.render 'user_layout',
                user_main: 'user_contact'
                


    Template.user_layout.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))
        @autorun -> Meteor.subscribe('ancestor_id_docs', null, FlowRouter.getParam('username'))
        @autorun -> Meteor.subscribe('ancestor_ids', null, FlowRouter.getParam('username'))

        
    # Template.user_layout.onRendered ->
    #     Meteor.setTimeout =>
    #         $('.menu .item').tab()
    #     , 1000

    
    
    Template.user_layout.helpers
        # person: -> Meteor.users.findOne username:FlowRouter.getParam('username')
        
        user_docs: ->
            person = Meteor.users.findOne username:FlowRouter.getParam('username')
            Docs.find
                author_id:person._id
        
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
    Template.user_layout.events
        'click #logout': -> AccountsTemplates.logout()
