Template.child_view.onCreated ->
    # @autorun => Meteor.subscribe 'child_docs', @data._id

Template.child_view.helpers
    doc: ->
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        Template.parentData()
    
    theme_tag_class: -> if @valueOf() in selected_tags.array() then 'active' else 'basic'
     
        
Template.child_view.events
    'click .theme_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
