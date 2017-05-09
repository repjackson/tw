@Files = new Meteor.Collection 'files'

Files.before.insert (userId, doc)->
    return


Files.after.update ((userId, doc, fieldNames, modifier, options) ->
), fetchPrevious: true



Files.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    parent_course: -> Courses.findOne @course_id

