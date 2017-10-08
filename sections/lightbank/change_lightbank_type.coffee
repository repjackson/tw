if Meteor.isClient
    Template.change_lightbank_type.events
        'click #make_journal_prompt': ->
            Docs.update @_id,
                $set: lightbank_type: 'journal_prompt'
        
        'click #make_passage': ->
            Docs.update @_id,
                $set: lightbank_type: 'passage'
        
        'click #make_poem': ->
            Docs.update @_id,
                $set: lightbank_type: 'poem'
        
        'click #make_quote': ->
            Docs.update @_id,
                $set: lightbank_type: 'quote'
        
        'click #make_custom': ->
            Docs.update @_id,
                $set: lightbank_type: 'custom'
        
    Template.change_lightbank_type.helpers
        poem_button_class: -> 
            lightbank_doc = Docs.findOne @_id
            if lightbank_doc.lightbank_type is 'poem' then 'blue' else 'basic'
        passage_button_class: -> 
            lightbank_doc = Docs.findOne @_id
            if lightbank_doc.lightbank_type is 'passage' then 'blue' else 'basic'
        quote_button_class: -> 
            lightbank_doc = Docs.findOne @_id
            if lightbank_doc.lightbank_type is 'quote' then 'blue' else 'basic'
        journal_prompt_button_class: -> 
            lightbank_doc = Docs.findOne @_id
            if lightbank_doc.lightbank_type is 'journal_prompt' then 'blue' else 'basic'
        custom_button_class: -> 
            lightbank_doc = Docs.findOne @_id
            if lightbank_doc.lightbank_type is 'custom' then 'blue' else 'basic'
        
        
        is_custom: -> 
            lightbank_doc = Docs.findOne @_id
            lightbank_doc.lightbank_type is 'custom'
        is_poem: -> 
            lightbank_doc = Docs.findOne @_id
            lightbank_doc.lightbank_type is 'poem'
        is_quote: -> 
            lightbank_doc = Docs.findOne @_id
            lightbank_doc.lightbank_type is 'quote'
        is_passage: -> 
            lightbank_doc = Docs.findOne @_id
            lightbank_doc.lightbank_type is 'passage'
        is_journal_prompt: -> 
            lightbank_doc = Docs.findOne @_id
            lightbank_doc.lightbank_type is 'journal_prompt'
                