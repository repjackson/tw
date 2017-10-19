if Meteor.isClient
    Template.view_goal.onCreated ->
    
    Template.view_goal.helpers

                
    Template.view_goal.events
        'click #delete_doc': ->
            if confirm 'Delete this goal?'
                Docs.remove @_id
                FlowRouter.go '/goals'
    
