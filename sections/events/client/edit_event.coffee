Template.edit_event.events
    'click #delete_doc': ->
        swal {
            title: 'Remove Event?'
            type: 'warning'
            animation: true
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Docs.remove @_id
            swal 'Removed', 'success'
            FlowRouter.go '/events'

# Template.event_tag_selection.onCreated -> 
#     self = @
#     @autorun => 
#         Meteor.subscribe('facet', 
#             selected_theme_tags.array()
#             selected_author_ids.array()
#             selected_location_tags.array()
#             selected_intention_tags.array()
#             selected_timestamp_tags.array()
#             type='event_tag'
#             author_id=null
#             parent_id=null
#             tag_limit=20
#             doc_limit=null
#             view_published=null
#             view_read=null
#             view_bookmarked=null
#             view_resonates=null
#             view_complete=null
#             )

Template.edit_event.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='event'
            author_id=null
            parent_id=null
            tag_limit=50
            doc_limit=5
            view_published=null
            view_read=null
            view_bookmarked=null
            view_resonates=null
            view_complete=null
            )


Template.event_tag_selection.helpers
    event_tags: -> 
        Docs.find {type: 'event_tag'},
            limit: 7
         
Template.event_tag_selection.helpers
    event_tag_class: ->
        event_doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @icon_class in event_doc.tags then 'blue raised' else ''
    
    event_tag_selected: ->
        event_doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @icon_class in event_doc.tags then true else false
         
Template.event_tag_selection.events
    'click .event_tag': (e,t)->
        # console.log @
        event_doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log event_doc
        if @icon_class in event_doc.tags
            Docs.update event_doc._id,
                $pull: tags: @icon_class
        else
            Docs.update event_doc._id,
                $addToSet: tags: @icon_class
         