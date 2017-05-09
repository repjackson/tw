@Courses = new Meteor.Collection 'courses'

Courses.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    # doc.points = 0
    doc.students = []
    doc.modules = []
    doc.published = false
    return


Courses.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.student_count = doc.students?.length
    doc.module_count = doc.modules?.length
), fetchPrevious: true



Courses.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    parent_doc: -> Docs.findOne @parent_id

