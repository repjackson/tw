if Meteor.isClient
    FlowRouter.route '/profile/:username', 
        name: 'profile_home'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_about'
    FlowRouter.route '/profile/:username/about', 
        name: 'profile_about'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_about'
    
    FlowRouter.route '/profile/:username/social', 
        name: 'profile_social'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_social'
    
    FlowRouter.route '/profile/:username/clouds', 
        name: 'profile_clouds'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_clouds'
    
    FlowRouter.route '/profile/:username/contact', 
        name: 'profile_contact'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_contact'
    
    FlowRouter.route '/profile/:username/courses', 
        name: 'profile_courses'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_courses'
    
    FlowRouter.route '/profile/:username/quizes', 
        name: 'profile_quizes'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_quizes'

    FlowRouter.route '/profile/:username/journal', 
        name: 'profile_journal'
        action: (params) ->
            BlazeLayout.render 'profile_layout',
                sub_nav: 'member_nav'
                profile_content: 'profile_journal'





    Template.profile_layout.onCreated ->
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))

        
    Template.profile_layout.onRendered ->
    
    
    Template.profile_about.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 
    
    Template.profile_layout.helpers
        person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 
        is_user: -> FlowRouter.getParam('username') is Meteor.user()?.username
        
    Template.profile_layout.events
