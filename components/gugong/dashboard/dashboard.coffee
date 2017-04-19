if Meteor.isClient
    FlowRouter.route '/dashboard', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'gugong_nav'
            main: 'member_dashboard'
