if Meteor.isClient
    Template.nav.events
        'click #logout': -> 
            AccountsTemplates.logout()
            
        
    Template.nav.helpers

    # Template.nav.onCreated ->
    #     self = @
    #     self.autorun ->
    #         self.subscribe 'herd', Meteor.user().profile.current_herd_id
    


# if Meteor.isServer
#     Meteor.methods
#         parse: ->
#             file = Assets.getText('members.csv')
#             Papa.parse file, 
#                 header: true
#                 complete: (results) ->
#                     for person in results.data
#                         # split_tags = person.SKILLS.split("/")
#                         # console.log split_tags
#                         if person.EMAIL
#                             # console.log person.EMAIL
#                             found = Accounts.findUserByEmail(person.EMAIL)
#                             # found = Meteor.users.findOne({emails[0]["address"]: email})
#                             console.log found._id
#                             console.log person.WEBSITE
#                             console.log found.WEBSITE
#                             Meteor.users.update found._id,
#                                 $set: "WEBSITE": person.WEBSITE
#                                 # console.log person.email
#                             # else
#                             #     person.image_id = 'blank_profile'
#                             #     person.tags = split_tags
#                             #     Accounts.createUser 
#                             #         email: person.EMAIL
#                             #         profile: person
                                    
