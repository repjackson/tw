FlowRouter.route '/dashboard', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'member_nav'
        main: 'dashboard'


Template.dashboard.events
    'click #logout': -> AccountsTemplates.logout()
