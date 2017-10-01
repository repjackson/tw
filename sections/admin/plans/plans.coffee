if Meteor.isClient
    FlowRouter.route '/plans', action: ->
        BlazeLayout.render 'layout',
            # sub_nav: 'admin_nav'
            main: 'plans'

    Template.plans.onCreated ->
        @autorun -> Meteor.subscribe('docs', selected_theme_tags.array(), 'plan')
    
    Template.plans.helpers
        plans: -> 
            Docs.find type: 'plan'
                
                
    Template.plans.events
        'click #add_plan': ->
            id = Docs.insert
                type: 'plan'
            FlowRouter.go "/edit/#{id}"
    
    Template.plan.helpers
    
    Template.plan.events
    
    Template.edit_plan.events
        'click #delete_plan': ->
            if confirm 'Delete this Plan?'
                Docs.remove @_id
                FlowRouter.go '/plans'
    
    
    
