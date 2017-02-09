

FlowRouter.route '/', action: ->
    BlazeLayout.render 'layout', 
        main: 'home'


FlowRouter.route '/contact', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'contact'

FlowRouter.route '/about', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'about'




