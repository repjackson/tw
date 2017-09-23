Template.toggle_image.events
    'change #toggle_image': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_image').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                has_image: value
        
Template.toggle_youtube.events
    'change #toggle_youtube': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_youtube').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                has_youtube: value
        
Template.toggle_content.events
    'change #toggle_content': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_content').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                has_content: value
        
Template.toggle_title.events
    'change #toggle_title': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_title').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                has_title: value
        
Template.toggle_journal_prompt.events
    'change #toggle_journal_prompt': (e,t)->
        value = $('#toggle_journal_prompt').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                journal_prompt: value
        
        
# button toggles
        
Template.toggle_resonates_button.events
    'change #toggle_resonates': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_resonates').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                can_resonate: value
        
Template.toggle_bookmarkable_button.events
    'change #toggle_bookmarkable': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_bookmarkable').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                can_bookmark: value
        
Template.toggle_complete_button.events
    'change #toggle_complete': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_complete').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                can_complete: value
                
Template.toggle_journal_prompt.events
    'change #toggle_journal_prompt': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_journal_prompt').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                is_journal_prompt: value
