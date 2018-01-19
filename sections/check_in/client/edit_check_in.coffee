Template.edit_checkin.events
    'click #delete_doc': ->
        swal {
            title: 'Remove Check-In?'
            type: 'warning'
            animation: true
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Docs.remove @_id
            # swal 'Removed', 'success'
            FlowRouter.go '/checkins/mine'

# Template.check_in_tag_selection.onCreated -> 
#     self = @
#     @autorun => 
#         Meteor.subscribe('facet', 
#             selected_theme_tags.array()
#             selected_author_ids.array()
#             selected_location_tags.array()
#             selected_intention_tags.array()
#             selected_timestamp_tags.array()
#             type='check_in_tag'
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

Template.edit_checkin.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='checkin'
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


Template.check_in_tag_selection.helpers
    check_in_tags: -> 
        Docs.find {type: 'check_in_tag'},
            limit: 7
         
Template.check_in_tag_selection.helpers
    check_in_tag_class: ->
        check_in_doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @icon_class in check_in_doc.tags then 'blue raised' else ''
    
    check_in_tag_selected: ->
        check_in_doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @icon_class in check_in_doc.tags then true else false
         
Template.check_in_tag_selection.events
    'click .check_in_tag': (e,t)->
        # console.log @
        check_in_doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log check_in_doc
        if @icon_class in check_in_doc.tags
            Docs.update check_in_doc._id,
                $pull: tags: @icon_class
        else
            Docs.update check_in_doc._id,
                $addToSet: tags: @icon_class
         