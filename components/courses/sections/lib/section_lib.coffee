@Sections = new Meteor.Collection 'sections'

Sections.before.insert (userId, doc)->
    doc.sections = []
    doc.published = false
    return


Sections.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.section_count = doc.sections?.length
), fetchPrevious: true



Sections.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    parent_module: -> Modules.findOne @module_id

