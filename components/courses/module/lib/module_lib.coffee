@Modules = new Meteor.Collection 'modules'

Modules.before.insert (userId, doc)->
    doc.sections = []
    doc.published = false
    return


Modules.after.update ((userId, doc, fieldNames, modifier, options) ->
    # doc.section_count = doc.sections?.length
), fetchPrevious: true



Modules.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    parent_course: -> Courses.findOne @course_id

