FlowRouter.route '/account', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'member_nav'
        main: 'account'