if Meteor.isClient
    Template.edit_lightbank.events
        'click #delete_doc': ->
            swal {
                title: 'Remove Lightbank Entry?'
                type: 'warning'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'No'
                confirmButtonText: 'Remove'
                confirmButtonColor: '#da5347'
            }, =>
                swal 'Removed', 'success'
                Docs.remove @_id
                FlowRouter.go '/lightbank'
                
    
    Template.edit_lightbank.helpers
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
                