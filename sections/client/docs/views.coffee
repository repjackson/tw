Template.q_a.helpers
    sessions: ->
        Docs.find
            parent_id: FlowRouter.getParam('doc_id')
            type: 'session'
    
    questions: ->
        Docs.find
            parent_id: FlowRouter.getParam('doc_id')
            type: $ne: 'session'


Template.sessions.helpers
    my_sessions: ->
        Docs.find
            type: 'session'
            author_id: Meteor.userId()
            parent_id: FlowRouter.getParam('doc_id')


Template.child_view.helpers
    child_view_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.child_fields
    
    doc: ->
        # doc = Docs.findOne FlowRouter.getParam('doc_id')
        Template.parentData()
    
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
        
Template.custom_field_input.events
    'blur .custom_field_input': (e,t)->
        custom_field_input = $(e.currentTarget).closest('.custom_field_input').val()
        console.log custom_field_input
        console.log Template.parentData(2)
        # Docs.update @_id,
        #     $set: created_date: created_date
        Docs.update Template.parentData(2)._id,
            $set: "#{@slug}": custom_field_input
            
        
Template.custom_field_input.helpers
    slug_value: -> 
        Docs.findOne(Template.parentData(2)._id)["#{@slug}"]
Template.view_custom_field.helpers
    slug_value: -> 
        Docs.findOne(Template.parentData(2)._id)["#{@slug}"]
        
        
        
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
        
