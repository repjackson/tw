if Meteor.isClient
    
    FlowRouter.route '/lightbank/:doc_id/edit',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'lightbank_edit'
    
    
    
    
    Template.lightbank_edit.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.lightbank_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    Template.lightbank_edit.events
        'click #save_doc': ->
            # selected_tags.clear()
            # selected_tags.push tag for tag in @tags
    
        'click #delete_doc': ->
            if confirm 'Delete this doc?'
                Docs.remove @_id
                FlowRouter.go '/lightbank'


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
        
        'change #toggle_journal_prompt': (e,t)->
            value = $('#toggle_journal_prompt').is(":checked")
            Docs.update FlowRouter.getParam('doc_id'), 
                $set:
                    journal_prompt: value
        
        # button toggles
        
        'change #toggle_resonates': (e,t)->
            # console.log e.currentTarget.value
            value = $('#toggle_resonates').is(":checked")
            Docs.update FlowRouter.getParam('doc_id'), 
                $set:
                    can_resonate: value
        
        'change #toggle_bookmarkable': (e,t)->
            # console.log e.currentTarget.value
            value = $('#toggle_bookmarkable').is(":checked")
            Docs.update FlowRouter.getParam('doc_id'), 
                $set:
                    can_bookmark: value
        
        'change #toggle_complete': (e,t)->
            # console.log e.currentTarget.value
            value = $('#toggle_complete').is(":checked")
            Docs.update FlowRouter.getParam('doc_id'), 
                $set:
                    can_complete: value
