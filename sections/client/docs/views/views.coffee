Template.child_view.onCreated ->
    # @autorun => Meteor.subscribe 'child_docs', @data._id
Template.child_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000


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
    has_title: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'title' in doc.child_fields
    
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'content' in doc.child_fields
        
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'tags' in doc.child_fields
        
    child_custom_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.custom_fields
        
Template.child_view.events
    'click #add_key_value': (e,t)->
        console.log @
        # console.log t.find
        custom_key = $('.custom_key').val()
        custom_value = $('.custom_value').val()
        
        Docs.update @_id,
            $addToSet: 
                "custom_key_values": 
                    key: custom_key
                    value: custom_value
        $('.custom_key').val('')
        $('.custom_value').val('')
        
        
        
    'click .remove_custom_field': (e,t)->
        # console.log @
        parent = Template.currentData()
        # console.log parent
        Docs.update parent._id,
            $pull: custom_key_values: @
        
