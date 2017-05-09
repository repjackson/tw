@Questions = new Meteor.Collection 'questions'

Questions.before.insert (userId, doc)->
    doc.Questions = []
    doc.published = false
    return


Questions.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.section_count = doc.questions?.length
), fetchPrevious: true



Questions.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    parent_module: -> Modules.findOne @module_id

