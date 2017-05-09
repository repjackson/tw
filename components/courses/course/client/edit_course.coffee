FlowRouter.route '/course/:course_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_course'

Template.edit_course.onCreated ->
    @autorun -> Meteor.subscribe 'course_by_id', FlowRouter.getParam('course_id')


Template.edit_course.helpers
    course: -> Courses.findOne FlowRouter.getParam('course_id')
    
    getFEContext: ->
        @current_doc = Courses.findOne @_id
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
        }
    
    
    
    
    
    
Template.edit_course.events
    'blur #title': (e,t)->
        # alert 'hi'
        title = $(e.currentTarget).closest('#title').val()
        Courses.update @_id,
            $set: title: title
    'click #delete': ->
        self = @
        swal {
            title: 'Delete?'
            text: '[need code to delete modules/sections]'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Courses.remove self._id
            FlowRouter.go "/courses"


            
    'blur #slug': (e,t)->
        # alert 'hi'
        slug = $(e.currentTarget).closest('#slug').val()
        Courses.update @_id,
            $set: slug: slug
            
    "change input[type='file']": (e) ->
        doc_id = @_id
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
                    Courses.update doc_id, $set: image_id: res.public_id
                return

    'keydown #input_image_id': (e,t)->
        if e.which is 13
            doc_id = @_id
            image_id = $('#input_image_id').val().toLowerCase().trim()
            if image_id.length > 0
                Courses.update doc_id,
                    $set: image_id: image_id
                $('#input_image_id').val('')

    'change #price': ->
        price = parseInt $('#price').val()

        Courses.update @_id,
            $set: price: price
            
    'blur #subtitle': ->
        subtitle = $('#subtitle').val()
        Courses.update @_id,
            $set: subtitle: subtitle
            


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
                    Courses.update @_id, 
                        $unset: image_id: 1

                else
                    throw new Meteor.Error "it failed miserably"

    #         console.log Cloudinary
    # 		Cloudinary.delete "37hr", (err,res) ->
    # 		    if err 
    # 		        console.log "Upload Error: #{err}"
    # 		    else
    #     			console.log "Upload Result: #{res}"
    #                 # Courses.update @_id, 
    #                 #     $unset: image_id: 1

    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        Courses.update @_id,
            $set: description: html
                
    'click #publish': -> Courses.update @_id, $set: published: true
    'click #unpublish': -> Courses.update @_id, $set: published: false

