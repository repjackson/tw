FlowRouter.route '/demo', action: ->
    BlazeLayout.render 'layout', 
        # sub_nav: 'demo_nav'
        main: 'member_demo'


FlowRouter.route '/demo/members', action: ->
    BlazeLayout.render 'layout', 
        sub_nav: 'demo_nav'
        main: 'member_demo'


FlowRouter.route '/demo/events', action: ->
    BlazeLayout.render 'layout', 
        sub_nav: 'demo_nav'
        main: 'event_demo'


