FlowRouter.route '/file/:file_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_file'

if Meteor.isClient
    Template.edit_file.onCreated ->
        @autorun -> Meteor.subscribe 'file', @_id
    
    
    Template.edit_file.helpers
        file: -> Files.findOne @_id
        
        getFEContext: ->
            @current_doc = Files.findOne @_id
            self = @
            {
                _value: self.current_doc.description
                _keepMarkers: true
                _className: 'froala-reactive-meteorized-override'
                toolbarInline: false
                initOnClick: false
                imageInsertButtons: ['imageBack', '|', 'imageByURL']
                tabSpaces: false
                height: 300
                '_onsave.before': (e, editor) ->
                    # Get edited HTML from Froala-Editor
                    newHTML = editor.html.get(true)
                    # Do something to update the edited value provided by the Froala-Editor plugin, if it has changed:
                    if !_.isEqual(newHTML, self.current_doc.description)
                        # console.log 'onSave HTML is :' + newHTML
                        Files.update { _id: self.current_doc._id }, $set: description: newHTML
                    false
                    # Stop Froala Editor from POSTing to the Save URL
            }
    
            
            
    Template.edit_file.events
        'click #save_file': ->
            Session.set 'editing_id', null
    
        'keydown #add_tag': (e,t)->
            if e.which is 13
                file_id = @_id
                tag = $('#add_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Files.update file_id,
                        $addToSet: tags: tag
                    $('#add_tag').val('')
    
        'click .file_tag': (e,t)->
            tag = @valueOf()
            Files.update @_id,
                $pull: tags: tag
            $('#add_tag').val(tag)
                
                
        'blur #link': ->
            link = $('#link').val()
            Files.update @_id,
                $set: link: link
            
        'blur #title': ->
            title = $('#title').val()
            Files.update @_id,
                $set: title: title
            
                

    
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
                Meteor.call "c.delete_by_public_id", @image_id, (err,res) ->
                    if not err
                        # Do Stuff with res
                        # console.log res
                        Files.update @_id, 
                            $unset: image_id: 1
    
                    else
                        throw new Meteor.Error "it failed miserably"
    
        #         console.log Cloudinary
        # 		Cloudinary.delete "37hr", (err,res) ->
        # 		    if err 
        # 		        console.log "Upload Error: #{err}"
        # 		    else
        #     			console.log "Upload Result: #{res}"
        #                 # Files.update @_id, 
        #                 #     $unset: image_id: 1
    
                
        'click #delete': ->
            swal {
                title: 'Delete file?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                doc = Files.findOne @_id
                Files.remove doc._id, ->
                    FlowRouter.go "/lightbank"
    
    
        'blur .froala-container': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            file_id = @_id
    
            Files.update file_id,
                $set: 
                    description: html
                    # snippet: snippet
    
    
    


