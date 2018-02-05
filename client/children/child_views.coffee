    
Template.child_docs.onCreated ->
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')

# Template.child_docs.onRendered ->
#     # Meteor.setTimeout ->
#     #     $('.progress').progress()
#     # , 2000
#     Meteor.setTimeout ->
#         $('.ui.accordion').accordion()
#     , 2000
    

Template.child_docs.helpers
    child_docs: ->
        Docs.find {}

Template.child_docs.events
    'click #call_watson': ->    