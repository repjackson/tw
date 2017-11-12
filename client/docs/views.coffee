Template.child_view.onCreated ->
    # @autorun => Meteor.subscribe 'child_docs', @data._id

Template.child_view.helpers
    child_view_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.child_fields
    
    doc: ->
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        Template.parentData()
    
    grandchildren: ->
        parent = Template.parentData()
        Docs.find parent_id: @_id 
    
    child_custom_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.custom_fields
     
    theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
     
        
Template.child_view.events
    'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
