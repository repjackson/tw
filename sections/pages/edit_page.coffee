if Meteor.isClient
    Template.edit_page.onCreated ->
        @autorun -> Meteor.subscribe 'page_by_id', FlowRouter.getParam('page_id')
    
    
    Template.edit_page.helpers
        page: -> 
            Pages.findOne
                _id: FlowRouter.getParam('page_id')
        
    
        getFEContext: ->
            @current_doc = Pages.findOne FlowRouter.getParam('page_id')
            self = @
            {
                _value: self.current_doc.body
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
                    if !_.isEqual(newHTML, self.current_doc.body)
                        # console.log 'onSave HTML is :' + newHTML
                        Pages.update { _id: self.current_doc._id }, $set: body: newHTML
                    false
                    # Stop Froala Editor from POSTing to the Save URL
            }
            
            
    Template.edit_page.events
        'click #save_page': ->
            FlowRouter.go "/#{@name}"



        'blur #name': ->
            name = $('#name').val()
            Pages.update FlowRouter.getParam('page_id'),
                $set: name: name


        "change input[type='file']": (e) ->
            page_id = FlowRouter.getParam('page_id')
            files = e.currentTarget.files
    
    
            Cloudinary.upload files[0],
                # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
                # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
                (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                    # console.log "Upload Error: #{err}"
                    # console.dir res
                    if err
                        console.error 'Error uploading', err
                    else
                        Pages.update page_id, $set: image_id: res.public_id
                    return
    
        'keydown #input_image_id': (e,t)->
            if e.which is 13
                page_id = FlowRouter.getParam('page_id')
                image_id = $('#input_image_id').val().toLowerCase().trim()
                if image_id.length > 0
                    Pages.update page_id,
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
                Meteor.call "c.delete_by_public_id", @image_id, (err,res) ->
                    if not err
                        # Do Stuff with res
                        # console.log res
                        Pages.update FlowRouter.getParam('page_id'), 
                            $unset: image_id: 1
    
                    else
                        throw new Meteor.Error "it failed miserably"
    
        #         console.log Cloudinary
        # 		Cloudinary.delete "37hr", (err,res) ->
        # 		    if err 
        # 		        console.log "Upload Error: #{err}"
        # 		    else
        #     			console.log "Upload Result: #{res}"
        #                 # Pages.update FlowRouter.getParam('page_id'), 
        #                 #     $unset: image_id: 1
    

        'blur .froala-container': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            # snippet = $('#snippet').val()
            # if snippet.length is 0
            #     snippet = $(html).text().substr(0, 300).concat('...')
            page_id = FlowRouter.getParam('page_id')
    
            Pages.update page_id,
                $set: 
                    body: html
                    # snippet: snippet
    
        # 'blur #snippet': (e,t)->
        #     text = $('#snippet').val()
        #     page_id = FlowRouter.getParam('page_id')
    
        #     Pages.update page_id,
        #         $set: 
        #             snippet: text
    
    
        'click #upload_widget_opener': (e,t)->
            cloudinary.openUploadWidget {
                cloud_name: 'facet'
                upload_preset: 'rodonu5a'
            }, (error, result) ->
                # console.log error, result
                Pages.update FlowRouter.getParam('page_id'),
                    $addToSet: image_array: $each: result

        'click #delete': ->
            swal {
                title: 'Delete?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                page = Pages.findOne FlowRouter.getParam('page_id')
                Pages.remove page._id, ->
                    FlowRouter.go "/"





if Meteor.isServer
    Meteor.publish 'page_by_id', (id)->
        Pages.find id