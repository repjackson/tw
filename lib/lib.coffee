FlowRouter.route '/sol',
  triggersEnter: [ (context, redirect) ->
    redirect '/course/view/TTNQCYM5xMTHSHs3q'
    return
 ]

FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'


FlowRouter.route '/', action: ->
    BlazeLayout.render 'layout', 
        main: 'home'


FlowRouter.route '/contact', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'contact'

FlowRouter.route '/about', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'about'




Meteor.users.helpers
    name: -> 
        if @profile?.first_name and @profile?.last_name
            "#{@profile.first_name}  #{@profile.last_name}"