@Tags = new Meteor.Collection 'tags'


FlowRouter.route '/', action: ->
    BlazeLayout.render 'layout', 
        main: 'home'


FlowRouter.route '/features', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'features'

FlowRouter.route '/faq', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'faq'

FlowRouter.route '/pricing', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'pricing'

FlowRouter.route '/about', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'about'




