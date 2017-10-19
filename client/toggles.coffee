Template.toggle_component.helpers
    has_component: -> 
        name_input = @name
        # console.log @
        has_component = Docs.findOne(FlowRouter.getParam('doc_id'))["components"]["#{name_input}"]
        # if has_component then console.log("has #{name_input}") else console.log("doesnt have #{name_input}")
        return has_component
        
    button_class: ->
        name_input = @name
        # console.log @
        has_component = Docs.findOne(FlowRouter.getParam('doc_id'))["components"]["#{name_input}"]
        if has_component then 'blue' else 'basic'
        
Template.toggle_component.events
    'click .toggle_component': (e,t)->
        name_input = Template.currentData().name
        $(e.currentTarget).closest('#toggle_component').transition('pulse')
        has_component = Docs.findOne(FlowRouter.getParam('doc_id'))["components"]?["#{name_input}"]
        has_component = !has_component
        # console.log 'name', Template.currentData().name
        Docs.update FlowRouter.getParam('doc_id'), 
            $set: "components.#{name_input}": has_component
        
# Template.toggle_image.events
#     'click #toggle_image': (e,t)->
#         $(e.currentTarget).closest('#toggle_image').transition('pulse')
#         has_image = Docs.findOne(FlowRouter.getParam('doc_id')).has_image
#         has_image = !has_image
#         Docs.update FlowRouter.getParam('doc_id'), 
#             $set: has_image: has_image
        
# Template.toggle_youtube.events
#     'click #toggle_youtube': (e,t)->
#         $(e.currentTarget).closest('#toggle_youtube').transition('pulse')
#         has_youtube = Docs.findOne(FlowRouter.getParam('doc_id')).has_youtube
#         has_youtube = !has_youtube
#         Docs.update FlowRouter.getParam('doc_id'), 
#             $set: has_youtube: has_youtube
        
# Template.toggle_content.events
#     'click #toggle_content': (e,t)->
#         $(e.currentTarget).closest('#toggle_content').transition('pulse')
#         has_content = Docs.findOne(FlowRouter.getParam('doc_id')).has_content
#         has_content = !has_content
#         Docs.update FlowRouter.getParam('doc_id'), 
#             $set: has_content: has_content
        
        
Template.toggle_title.events
    'click #toggle_title': (e,t)->
        $(e.currentTarget).closest('#toggle_title').transition('pulse')
        has_title = Docs.findOne(FlowRouter.getParam('doc_id')).has_title
        has_title = !has_title
        Docs.update FlowRouter.getParam('doc_id'), 
            $set: has_title: has_title
        
         
Template.toggle_number.events
    'change #toggle_number': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_number').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                has_number: value
        
Template.toggle_icon.events
    'change #toggle_icon': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_icon').is(":checked")
        Docs.update FlowRouter.getParam('doc_id'), 
            $set:
                has_icon: value
        
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


# Viewing

Template.toggle_view_complete.events
    'change #toggle_view_complete': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_view_complete').is(":checked")
        Session.set 'view_complete', value
        
Template.toggle_view_complete.helpers
    viewing_complete: -> Session.get 'view_complete'
    
Template.toggle_view_incomplete.events
    'change #toggle_view_incomplete': (e,t)->
        # console.log e.currentTarget.value
        value = $('#toggle_view_incomplete').is(":checked")
        Session.set 'view_incomplete', value
        
Template.toggle_view_incomplete.helpers
    viewing_incomplete: -> Session.get 'view_incomplete'
    
    