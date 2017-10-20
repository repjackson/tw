if Meteor.isClient
    FlowRouter.route '/branches', action: ->
        BlazeLayout.render 'layout',
            # sub_nav: 'admin_nav'
            main: 'branches'

    Template.branches.onCreated ->
        @autorun -> Meteor.subscribe('branches')
    
    Template.branches.helpers
        branches: -> 
            Docs.find type: 'branch'
                
                
    Template.branches.events
        'click #add_branch': ->
            id = Docs.insert
                type: 'branch'
    
    Template.branch.helpers
    
    Template.branch.events
    
    
if Meteor.isServer
    Meteor.publish 'branches', ->
        Docs.find
            type: 'branch'
