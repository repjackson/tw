Template.view_lightbank.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='lightbank'
            author_id=null
            parent_id=null
            tag_limit=10
            doc_limit=5
            view_published=null
            view_read=null
            view_bookmarked=null
            view_resonates=null
            view_complete=null
            view_images=null
            view_lightbank_type=null

            )

Template.view_lightbank.helpers
    type_label: ->
        label = switch @lightbank_type
            when 'journal_prompt' then 'Journal Prompt'
            when 'quote' then 'Quote'
            when 'poem' then 'Poem'
            else 'Lightbank Entry'
        label    
        
    lightbank_entry: -> Docs.findOne FlowRouter.getParam('doc_id')

    is_custom: -> 
        lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
        lightbank_doc.lightbank_type is 'custom'
    is_poem: -> 
        lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
        lightbank_doc.lightbank_type is 'poem'
    is_quote: -> 
        lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
        lightbank_doc.lightbank_type is 'quote'
    is_passage: -> 
        lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
        lightbank_doc.lightbank_type is 'passage'
    is_journal_prompt: -> 
        lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
        lightbank_doc.lightbank_type is 'journal_prompt'
            
Template.view_lightbank.events
    'click #delete_doc': ->
        swal {
            title: 'Remove Lightbank Entry?'
            type: 'warning'
            animation: true
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Docs.remove @_id, ->
                # swal 'Removed', 'success'
                Session.set 'editing', false

                FlowRouter.go '/lightbank'
            

            