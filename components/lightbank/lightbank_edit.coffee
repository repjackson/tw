if Meteor.isClient
    
    FlowRouter.route '/lightbank/edit/:doc_id',
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
        "change input[type='file']": (e) ->
            doc_id = @_id
            files = e.currentTarget.files
            console.log files
    
            Cloudinary.upload files[0],
                # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
                # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
                (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                    # console.log "Upload Error: #{err}"
                    # console.dir res
                    if err
                        console.error 'Error uploading', err
                    else
                        Docs.update doc_id, $set: image_id: res.public_id
                    return
    
        'keydown #input_image_id': (e,t)->
            if e.which is 13
                doc_id = @_id
                image_id = $('#input_image_id').val().toLowerCase().trim()
                if image_id.length > 0
                    Docs.update doc_id,
                        $set: image_id: image_id
                    $('#input_image_id').val('')
    
    
    
        'click #remove_photo': ->
            swal {
                title: 'Remove Photo?'
                type: 'warning'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'No'
                confirmButtonText: 'Remove'
                confirmButtonColor: '#da5347'
            }, =>
                doc = Docs.findOne @_id
                Meteor.call "c.delete_by_public_id", doc.image_id, (err,res) ->
                    if err
                        throw new Meteor.Error "it failed miserably"
                        # Do Stuff with res
                        # console.log res
                        # console.log doc._id
                    # else
                Docs.update doc._id, 
                    $unset: 
                        image_id: 1
                        image_url: 1
    
        #         console.log Cloudinary
        # 		Cloudinary.delete "37hr", (err,res) ->
        # 		    if err 
        # 		        console.log "Upload Error: #{err}"
        # 		    else
        #     			console.log "Upload Result: #{res}"
        #                 # Docs.update @_id, 
        #                 #     $unset: image_id: 1
    
    
        'blur #image_url': ->
            image_url = $('#image_url').val()
            Docs.update @_id,
                $set: image_url: image_url
                
        'click #saveDoc': ->
            FlowRouter.go "/lightbank/view/#{@_id}"
            # selected_tags.clear()
            # selected_tags.push tag for tag in @tags
    
        'click #deleteDoc': ->
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
