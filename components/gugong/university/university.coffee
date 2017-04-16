FlowRouter.route '/university', action: ->
    BlazeLayout.render 'layout',
        sub_nav: 'gugong_nav'
        main: 'university'
