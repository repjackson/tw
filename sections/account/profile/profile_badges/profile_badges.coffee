
if Meteor.isClient
    Template.profile_badges.onCreated ->
        @autorun -> Meteor.subscribe 'profile_badges'

    Template.profile_badges.helpers 
        badges: ->
            Docs.find
                type: 'badge'

        badge_class: ->
            if Meteor.userId() in @acheiver_ids then '' else 'disabled'

    Template.profile_badges.events
        'click .enable': ->
            Docs.update @_id,
                $addToSet: acheiver_ids: Meteor.userId()
        'click .disable': ->
            Docs.update @_id,
                $pull: acheiver_ids: Meteor.userId()

        'click #add_badge': ->
            Docs.insert
                type: 'badge'
                acheiver_ids: []


if Meteor.isServer
    Meteor.publish 'profile_badges', ->
        Docs.find
            type: 'badge'
                
