Template.view_databank.onCreated ->
    Meteor.subscribe 'fields'

    @autorun => Meteor.subscribe 'facet', 
        selected_theme_tags.array()
        selected_author_ids.array()
        selected_location_tags.array()
        selected_intention_tags.array()
        selected_timestamp_tags.array()
        type=null
        parent_id = FlowRouter.getParam('doc_id')
        view_private = Session.get 'view_private'
    # @autorun => Meteor.subscribe 'facet', 
    #     selected_theme_tags.array()
    #     selected_author_ids.array()
    #     selected_location_tags.array()
    #     selected_intention_tags.array()
    #     selected_timestamp_tags.array()
    #     type = null
    #     author_id = null
    #     parent_id = FlowRouter.getParam('doc_id')
    #     tag_limit = null
    #     doc_limit = 10
    #     # view_private = Session.get 'view_private'
    
Template.view_databank.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')


    databank_children: ->
        # Docs.find {parent_id:FlowRouter.getParam('doc_id')},
        Docs.find {type:'journal'},
            limit: 10
    
    facet_template: ->
        # console.log @valueOf()
        field_doc = Docs.findOne @valueOf()
        if field_doc
            switch field_doc.slug
                when 'tags' then 'tag_facet'
                when 'location_tags' then 'location_facet'
                when 'intention_tags' then 'intention_facet'
            
        
        
Template.edit_databank.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
                $('.menu .item').tab()
            , 1000
        
Template.view_databank_item.onCreated ->
    Meteor.subscribe 'fields'
    Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    
Template.edit_databank_item.onCreated ->
    Meteor.subscribe 'fields'
    
        
Template.edit_databank_item.helpers

    # doc: -> Docs.findOne FlowRouter.getParam('doc_id')

        
    
Template.view_databank_item.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')


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
    
Template.databank_card.onCreated ->
    @autorun => Meteor.subscribe 'child_docs', @data._id
    @autorun => Meteor.subscribe 'author', @data._id
    
Template.databank_card.helpers
    field_doc: ->
        field_doc = Docs.findOne @valueOf()
        # console.log 'db card field doc slug', field_doc.slug
        # console.log 'db card field doc template', field_doc.field_template
        field_doc
        # Docs.findOne Template.parentData(2)
Template.edit_databank_item.helpers
    field_doc: ->
        field_doc = Docs.findOne @valueOf()
        # console.log 'db card field doc slug', field_doc.slug
        # console.log 'db card field doc template', field_doc.field_template
        field_doc
        # Docs.findOne Template.parentData(2)
Template.view_databank_item.helpers
    field_doc: ->
        field_doc = Docs.findOne @valueOf()
        # console.log 'db card field doc slug', field_doc.slug
        # console.log 'db card field doc template', field_doc.field_template
        field_doc
        # Docs.findOne Template.parentData(2)
