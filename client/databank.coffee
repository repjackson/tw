# Template.view_bugs.onCreated -> 
#     self = @
#     @autorun => 
#         Meteor.subscribe('facet', 
#             selected_theme_tags.array()
#             selected_author_ids.array()
#             selected_location_tags.array()
#             selected_intention_tags.array()
#             selected_timestamp_tags.array()
#             type='bug_report'
#             author_id=null
#             parent_id=null
#             tag_limit=null
#             doc_limit=null
#             view_published=null
#             view_read=null
#             view_bookmarked=null
#             view_resonates=null
#             view_complete=Session.get 'view_complete'
#             )

    
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

    child_field_slugs: ->
        current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        parent_doc = Docs.findOne _id:current_doc.parent_id
        # console.log parent_doc.child_field_ids
        child_field_slugs = []
        # child_field_docs = Docs.find(_id:$in:parent_doc.child_field_ids).fetch()
        for child_field_id in parent_doc.child_field_ids
            child_field_doc = Docs.findOne child_field_id
            child_field_slugs.push child_field_doc.slug
        child_field_slugs
    
    field_edit_template: ->
        # console.log @
        return "edit_#{@}"
        
        
Template.view_databank_item.onCreated ->
    Meteor.subscribe 'fields'
    
Template.view_databank_item.helpers

    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    child_field_slugs: ->
        current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        parent_doc = Docs.findOne _id:current_doc.parent_id
        # console.log parent_doc.child_field_ids
        child_field_slugs = []
        # child_field_docs = Docs.find(_id:$in:parent_doc.child_field_ids).fetch()
        for child_field_id in parent_doc.child_field_ids
            child_field_doc = Docs.findOne child_field_id
            child_field_slugs.push child_field_doc.slug
        child_field_slugs
    
    field_view_template: ->
        # console.log @
        return "view_#{@}"
        
        
        