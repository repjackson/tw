if Meteor.isClient
    Template.me_card.onCreated ->
        @autorun -> 
            Meteor.subscribe('me_card', Template.currentData().author_id)
    
    Template.me_card.helpers
        me: -> 
            Meteor.user()

if Meteor.isServer
    Meteor.publish 'me_card', (id)->
        # console.log id
        Meteor.users.find id,
            fields:
                tags: 1
                profile: 1
                points: 1