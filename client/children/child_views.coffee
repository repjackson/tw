# Template.q_a.helpers
#     sessions: ->
#         Docs.find
#             parent_id: FlowRouter.getParam('doc_id')
#             type: 'session'
    
#     questions: ->
#         Docs.find
#             parent_id: FlowRouter.getParam('doc_id')
#             type: $ne: 'session'


# Template.sessions.helpers
#     my_sessions: ->
#         Docs.find
#             type: 'session'
#             author_id: Meteor.userId()
#             parent_id: FlowRouter.getParam('doc_id')


        
# Template.grid_item.helpers
#     card_class: -> 
#         if @can_access() then '' else 'noborders'



Template.view_nav.onCreated ->
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    
    
Template.child_docs.onCreated ->
    @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')

Template.child_docs.onRendered ->
    # Meteor.setTimeout ->
    #     $('.progress').progress()
    # , 2000
    Meteor.setTimeout ->
        $('.ui.accordion').accordion()
    , 2000
    

Template.child_docs.helpers
    child_docs: ->
        doc_id = FlowRouter.getParam('doc_id')
        Docs.find
            parent_id: doc_id

Template.child_docs.events
    'click #call_watson': ->    