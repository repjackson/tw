@Tickets = new Meteor.Collection 'tickets'

Tickets.before.insert (userId, doc)->
    doc.sections = []
    doc.published = false
    return


Tickets.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.section_count = doc.sections?.length
), fetchPrevious: true



Tickets.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

