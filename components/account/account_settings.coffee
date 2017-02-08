if Meteor.isClient
    Template.account_settings.onCreated ->
        @autorun -> Meteor.subscribe 'all_herds'
    

    
    
    
    Template.account_settings.helpers
        herd_memberships: ->
            if Meteor.user()
                herd_list = []
                for herd_id in Meteor.user().profile.herds
                    herd_object = Herds.findOne herd_id
                    herd_list.push herd_object
                return herd_list
                
                
if Meteor.isServer
    Meteor.publish 'all_herds', ->
        Herds.find()