Template.view_databank.onCreated ->
    # Meteor.subscribe 'fields'
    
Template.view_databank.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    facet_template: ->
        # console.log @valueOf()
        switch @valueOf()
            when 'tags' then 'tag_facet'
            when 'location_tags' then 'location_facet'
            when 'intention_tags' then 'intention_facet'
            
        
        
Template.edit_databank.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
        
        
        
Template.edit_databank_item.onCreated ->
    Meteor.subscribe 'fields'
    
        
Template.edit_databank_item.helpers

    # doc: -> Docs.findOne FlowRouter.getParam('doc_id')

        
# Template.view_databank_item.onCreated ->
#     Meteor.subscribe 'fields'
    
# Template.view_databank_item.helpers
#     doc: -> Docs.findOne FlowRouter.getParam('doc_id')


Template.toggle_key.helpers
    toggle_key_button_class: -> 
        current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log current_doc["#{@key}"]
        # console.log @key
        # console.log Template.parentData()
        # console.log Template.parentData()["#{@key}"]
        if @value
            if current_doc["#{@key}"] is @value then 'blue' else 'basic'
        else if current_doc["#{@key}"] is true then 'blue' else 'basic'


Template.toggle_key.events
    'click #toggle_key': ->
        # console.log @
        if @value
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": "#{@value}"
        else if Template.parentData()["#{@key}"] is true
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": false
        else
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": true
            

Template.child_card.onCreated ->
    @autorun => Meteor.subscribe 'child_docs', @data._id
    @autorun => Meteor.subscribe 'author', @data._id
    
