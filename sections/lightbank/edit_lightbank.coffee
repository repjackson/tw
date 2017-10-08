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
                
    
        'click #make_journal_prompt': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: lightbank_type: 'journal_prompt'
        
        'click #make_passage': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: lightbank_type: 'passage'
        
        'click #make_poem': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: lightbank_type: 'poem'
        
        'click #make_quote': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: lightbank_type: 'quote'
        
        'click #make_custom': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: lightbank_type: 'custom'
        
    Template.edit_lightbank.helpers
        lightbank_entry: -> Docs.findOne FlowRouter.getParam('doc_id')
        poem_button_class: -> 
            lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
            if lightbank_doc.lightbank_type is 'poem' then 'blue' else 'basic'
        passage_button_class: -> 
            lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
            if lightbank_doc.lightbank_type is 'passage' then 'blue' else 'basic'
        quote_button_class: -> 
            lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
            if lightbank_doc.lightbank_type is 'quote' then 'blue' else 'basic'
        journal_prompt_button_class: -> 
            lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
            if lightbank_doc.lightbank_type is 'journal_prompt' then 'blue' else 'basic'
        custom_button_class: -> 
            lightbank_doc = Docs.findOne FlowRouter.getParam('doc_id')
            if lightbank_doc.lightbank_type is 'custom' then 'blue' else 'basic'
        
        
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
                