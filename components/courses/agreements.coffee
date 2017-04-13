@Agreements = new Meteor.Collection 'agreements'

Agreements.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Agreements.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()


if Meteor.isServer
    Agreements.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
