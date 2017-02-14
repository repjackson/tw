FlowRouter.route '/courses/sol', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'sol'

if Meteor.isClient
    Template.sol.onCreated -> 
        @autorun -> Meteor.subscribe('sol')

    Template.sol.helpers
        modules: -> 
            Modules.find { }
    

    

    Template.view.events
    
        'click .edit': -> FlowRouter.go("/edit/#{@_id}")

    Template.sol.events
        'click #add_module': ->
            id = Modules.insert
                course: 'sol'
            FlowRouter.go "/edit_module/#{id}"
    
    


if Meteor.isServer
    Meteor.publish 'sol', ()->
    
        self = @
        match = {}

        # match.course = 'sol'        

        Modules.find match
    
