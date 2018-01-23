if Meteor.isClient
    # Template.view_media.onCreated ->
    #     @autorun => Meteor.subscribe 'new_facet', selected_theme_tags.array(), FlowRouter.getParam('doc_id')
    
    
    Template.view_media.events
        'click #add_item': ->
            id = Docs.insert
                parent_id: @_id
                type: 'media_item'
            FlowRouter.go "/edit/#{id}"
            
            
        
    Template.edit_media_item.events
        'click #delete_item': ->
            swal {
                title: 'Delete Media Entry?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                doc = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.remove doc._id, ->
                    FlowRouter.go "/view/#{doc._id}"