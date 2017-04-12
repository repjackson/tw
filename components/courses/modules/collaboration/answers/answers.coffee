@Answers = new Meteor.Collection 'answers'

Answers.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Answers.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()



if Meteor.isServer
    Answers.allow
        insert: (userId, doc) -> userId
        update: (userId, doc) -> userId is doc.author_id
        remove: (userId, doc) -> userId is doc.author_id
    
