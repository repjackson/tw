if Meteor.isClient
    Template.view_profile.onCreated ->
        @autorun -> Meteor.subscribe('profile', FlowRouter.getParam('user_id'))
        
    
    Template.view_profile.helpers
        person: -> 
            Meteor.users.findOne FlowRouter.getParam('user_id') 
        
    
    
    Template.view_profile.events
