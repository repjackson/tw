FlowRouter.route '/messages', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'messages'
