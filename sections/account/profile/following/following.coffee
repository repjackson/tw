if Meteor.isClient
    Template.following.onCreated ->
        @autorun => Meteor.subscribe 'following'
        @autorun => Meteor.subscribe 'followers'
        
    Template.following.helpers
        target_user: ->
            Meteor.users.findOne username: FlowRouter.getParam('username')
        is_following: ->
            target_user = Meteor.users.findOne username: FlowRouter.getParam('username')
            if target_user and target_user.followers 
                return Meteor.userId() in target_user.followers
    
        following: ->
            if Meteor.user() and Meteor.user().following
                following_array = []
                for following_id in Meteor.user()?.following
                    user = Meteor.users.findOne following_id
                    following_array.push user
                following_array
                
        followers: ->
            target_user = Meteor.users.findOne username: FlowRouter.getParam('username')
            if target_user and target_user.followers 
                followers_array = []
                for following_id in target_user.followers
                    user = Meteor.users.findOne following_id
                    followers_array.push user
                followers_array
    
    
    Template.following.events
        'click #follow': (e,t) -> 
            target_user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Meteor.users.update target_user._id, $addToSet: followers: Meteor.userId()
            $(e.currentTarget).closest('#follow').transition('pulse')
    
            # Meteor.call 'add_notification', Meteor.userId(), 'followed', target_user._id
    
        'click #unfollow': (e,t)-> 
            target_user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Meteor.users.update target_user._id, $pull: followers: Meteor.userId()
            $(e.currentTarget).closest('#unfollow').transition('pulse')
    
            # Meteor.call 'add_notification', Meteor.userId(), 'unfollowed', target_user._id



    Template.person_item.onRendered ->
        Meteor.setTimeout ->
            # $(e.currentTarget).closest('.item').transition('pulse')
            $('.item').transition('pulse')
        , 200
                
if Meteor.isServer
    Meteor.publish 'followers', ->
        user = Meteor.users.findOne Meteor.userId()
        Meteor.users.find
            _id: $in: [user.followers]
            
    Meteor.publish 'following', ->
        user = Meteor.users.findOne Meteor.userId()
        Meteor.users.find
            _id: $in: [user.following]
            