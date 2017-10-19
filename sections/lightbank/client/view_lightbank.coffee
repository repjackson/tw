Template.view_lightbank.helpers
    type_label: ->
        label = switch @lightbank_type
            when 'journal_prompt' then 'Journal Prompt'
            when 'quote' then 'Quote'
            when 'poem' then 'Poem'
            else 'Lightbank Entry'
        label    
        
        
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
            
        