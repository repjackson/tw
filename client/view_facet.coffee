Template.view_facet.onCreated ->
    @autorun => Meteor.subscribe 'new_facet', selected_theme_tags.array(), null, FlowRouter.getParam('doc_id')


Template.view_facet.helpers
    children: -> 
        parent = Docs.findOne _id:FlowRouter.getParam('doc_id')
        Docs.find {
            parent_id: FlowRouter.getParam('doc_id')
            type: parent.child_type
        }

    child_template: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        result = "#{doc.child_type}_card"
        # console.log result
        return result


Template.facet_card.helpers
    theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
    location_tag_class: -> if @valueOf() in selected_location_tags.array() then 'blue' else 'basic'

Template.facet_card.events
    'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
    'click .location_tag': -> if @valueOf() in selected_location_tags.array() then selected_location_tags.remove(@valueOf()) else selected_location_tags.push(@valueOf())


            
Template.view_facet.events
    'click #add_item': ->
        id = Docs.insert
            type: 'facet'
        FlowRouter.go "/edit/#{id}"
        
        
Template.edit_facet_item.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.edit_facet_item.helpers
    facet_item: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.edit_facet_item.events
    'click #delete_item': ->
        swal {
            title: 'Delete Entry?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            current_doc = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove current_doc._id, ->
                FlowRouter.go "/view/#{current_doc.parent_id}"        