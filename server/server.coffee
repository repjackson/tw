Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        true
        # # console.log 'user ' + userId + 'wants to modify doc' + doc._id
        # if userId and doc._id == userId
        #     # console.log 'user allowed to modify own account'
        #     true

# Kadira.connect('Dmhg2hdSobHy3fXWE', '940bb181-70ce-42c4-a557-77696e5da41d')



Meteor.publish 'userStatus', ->
    Meteor.users.find { 'status.online': true }, 
        fields: 
            points: 1
            tags: 1
            
            
            
Meteor.publish 'user_status_notification', ->
    Meteor.users.find('status.online': true).observe
        added: (id) ->
            console.log "#{id} just logged in"
        removed: (id) ->
            console.log "#{id} just logged out"


Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.cloudinary_key
    api_secret: Meteor.settings.cloudinary_secret


Accounts.onCreateUser (options, user) ->
    return user

# AccountsMeld.configure
#     askBeforeMeld: false
#     # meldDBCallback: meldDBCallback
#     # serviceAddedCallback: serviceAddedCallback


Docs.allow
    insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
    update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId
    remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or doc.author_id is userId


# AccountsMeld.configure
#     askBeforeMeld: false
#     # meldDBCallback: meldDBCallback
#     # serviceAddedCallback: serviceAddedCallback
