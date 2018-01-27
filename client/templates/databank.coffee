Template.view_databank.onCreated ->
    Meteor.subscribe 'fields'
    
Template.view_databank.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    child_field_slugs: ->
        current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        
    
    facet_template: ->
        # console.log @valueOf()
        switch @valueOf()
            when 'tags' then 'tag_facet'
            when 'location_tags' then 'location_facet'
            when 'intention_tags' then 'intention_facet'
            
        
Template.edit_databank_item.onCreated ->
    Meteor.subscribe 'fields'
    
        
Template.edit_databank_item.helpers

    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    field_edit_template: ->
        # console.log @
        return "edit_#{@}"
        
        
Template.view_databank_item.onCreated ->
    Meteor.subscribe 'fields'
    
Template.view_databank_item.helpers

    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
