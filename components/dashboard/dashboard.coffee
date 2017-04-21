if Meteor.isClient
    FlowRouter.route '/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            main: 'member_dashboard'
