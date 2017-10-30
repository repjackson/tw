FlowRouter.route '/components', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        main: 'components'
 
if Meteor.isClient
    Template.components.onCreated ->
        @autorun -> Meteor.subscribe 'components'
        
    Template.components.helpers
        components: ->
            Docs.find
                type: 'component'
            
    Template.components.events
        'click #add_component': ->
            Docs.insert
                type: 'component'
            
            
if Meteor.isServer
    Meteor.publish 'components', ->
        Docs.find
            type: 'component'