if Meteor.isClient
    
    FlowRouter.route '/service/:doc_id/edit',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'service_edit'
    
    
    
    
    Template.service_edit.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.service_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    Template.service_edit.events
        'click #save_doc': ->
            FlowRouter.go "/service/#{@_id}/view"
            # selected_tags.clear()
            # selected_tags.push tag for tag in @tags
    
        'click #delete_doc': ->
            if confirm 'Delete this doc?'
                Docs.remove @_id
                FlowRouter.go '/'


        # toggles
        
        'change #toggle_image': (e,t)->
            # console.log e.currentTarget.value
            value = $('#toggle_image').is(":checked")
            Docs.update FlowRouter.getParam('doc_id'), 
                $set:
                    has_image: value
        
        'change #toggle_youtube': (e,t)->
            # console.log e.currentTarget.value
            value = $('#toggle_youtube').is(":checked")
            Docs.update FlowRouter.getParam('doc_id'), 
                $set:
                    has_youtube: value
        
        'change #toggle_content': (e,t)->
            # console.log e.currentTarget.value
            value = $('#toggle_content').is(":checked")
            Docs.update FlowRouter.getParam('doc_id'), 
                $set:
                    has_content: value
        
