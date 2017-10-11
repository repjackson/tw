Template.view_lightbank.helpers
    type_label: ->
        label = switch @lightbank_type
            when 'journal_prompt' then 'Journal Prompt'
            when 'quote' then 'Quote'
            when 'poem' then 'Poem'
            else 'Lightbank Entry'
        label    