@Sections = new Meteor.Collection 'sections'

Sections.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Sections.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()



if Meteor.isServer
    Sections.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    