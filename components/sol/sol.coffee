FlowRouter.route '/courses/sol', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'sol'


FlowRouter.route '/courses/sol/front', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'sol_front'


    Template.view.events
    
        'click .edit': -> FlowRouter.go("/edit/#{@_id}")
    
    


if Meteor.isServer
    Meteor.publish 'sol', ()->
    
        self = @
        match = {}

        # match.course = 'sol'        

        Modules.find match
    
