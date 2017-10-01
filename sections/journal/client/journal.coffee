FlowRouter.route '/journal', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'journal'
