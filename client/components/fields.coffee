Template.edit_subtitle.events
    'blur #subtitle': ->
        subtitle = $('#subtitle').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: subtitle: subtitle
            
Template.group.events
    'blur #group': (e,t)->
        group = $(e.currentTarget).closest('#group').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: group: group
            
Template.author_name.events
    'blur #author_name': (e,t)->
        author_name = $(e.currentTarget).closest('#author_name').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: author_name: author_name
            
Template.edit_icon.events
    'blur #icon_class': (e,t)->
        val = $(e.currentTarget).closest('#icon_class').val()

        Docs.update FlowRouter.getParam('doc_id'),
            $set: icon_class: val
            
Template.created_date.helpers
    created_date: -> 
        console.log @timestamp
        @timestamp

Template.created_date.events
    'blur #created_date': ->
        created_date = $('#created_date').val()
        console.log created_date
        # Docs.update FlowRouter.getParam('doc_id'),
        #     $set: created_date: created_date
            
Template.plain.events
    'blur #plain': ->
        plain = $('#plain').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: plain: plain
            
            
# Template.child_tags.events
#     'keydown #add_tag': (e,t)->
#         if e.which is 13
#             tag = $('#add_tag').val().toLowerCase().trim()
#             if tag.length > 0
#                 Docs.update Template.parentData()._id,
#                     $addToSet: tags: tag
#                 $('#add_tag').val('')

#     'click .doc_tag': (e,t)->
#         tag = @valueOf()
#         Docs.update Template.parentData()._id,
#             $pull: tags: tag
#         $('#add_tag').val(tag)

Template.edit_tags.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update FlowRouter.getParam('doc_id'),
            $addToSet: tags: doc.name
        $('#theme_tag_select').val('')
   
    'keyup #theme_tag_select': (e,t)->
        e.preventDefault()
        val = $('#theme_tag_select').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update FlowRouter.getParam('doc_id'),
                        $addToSet: tags: val
                    $('#theme_tag_select').val ''
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(FlowRouter.getParam('doc_id')).tags.slice -1
            #         $('#theme_tag_select').val result[0]
            #         Docs.update FlowRouter.getParam('doc_id'),
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: tag
        $('#theme_tag_select').val(tag)
        
Template.edit_tags.helpers
    # editing_mode: -> 
    #     console.log Session.get 'editing'
    #     if Session.equals 'editing', true then true else false
    theme_select_settings: -> {
        position: 'top'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }


Template.edit_location_tags.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update FlowRouter.getParam('doc_id'),
            $addToSet: location_tags: doc.name
        $('#location_tag_select').val('')
   
   
    'keyup #add_location_tag': (e,t)->
        e.preventDefault()
        val = $('#add_location_tag').val().toLowerCase().trim()
        # console.log e
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update FlowRouter.getParam('doc_id'),
                        $addToSet: location_tags: val
                    $('#add_location_tag').val ''
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(FlowRouter.getParam('doc_id')).location_tags.slice -1
            #         $('#location_tag_select').val result[0]
            #         Docs.update FlowRouter.getParam('doc_id'),
            #             $pop: location_tags: 1


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: location_tags: tag
        $('#location_tag_select').val(tag)


Template.edit_location_tags.helpers
    location_select_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Location_tags
                field: 'name'
                matchAll: true
                template: Template.tag_pill
            }
            ]
    }

Template.edit_intention_tags.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update FlowRouter.getParam('doc_id'),
            $addToSet: intention_tags: doc.name
        $('#intention_tag_select').val('')
   
   
    'keyup #intention_tag_select': (e,t)->
        e.preventDefault()
        val = $('#intention_tag_select').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update FlowRouter.getParam('doc_id'),
                        $addToSet: intention_tags: val
                    $('#intention_tag_select').val ''
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(FlowRouter.getParam('doc_id')).intention_tags.slice -1
            #         $('#intention_tag_select').val result[0]
            #         Docs.update FlowRouter.getParam('doc_id'),
            #             $pop: intention_tags: 1

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: intention_tags: tag
        $('#intention_tag_select').val(tag)

Template.edit_intention_tags.helpers
    intention_select_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Intention_tags
                field: 'name'
                matchAll: true
                template: Template.tag_pill
            }
            ]
    }


Template.edit_dollar_price.events
    'change #dollar_price': ->
        dollar_price = parseInt $('#dollar_price').val()

        Docs.update FlowRouter.getParam('doc_id'),
            $set: dollar_price: dollar_price
            
Template.edit_point_price.events
    'change #point_price': ->
        point_price = parseInt $('#point_price').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: point_price: point_price
            
Template.bounty.events
    'change #bounty': ->
        bounty = parseInt $('#bounty').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: bounty: bounty
            
            
Template.edit_number.events
    'blur #number': (e) ->
        # console.log @
        val = $(e.currentTarget).closest('#number').val()
        number = parseInt val
        # console.log number
        Docs.update FlowRouter.getParam('doc_id'),
            $set: number: number
            
Template.edit_quantity.events
    'blur #quantity': (e) ->
        # console.log @
        val = $(e.currentTarget).closest('#quantity').val()
        quantity = parseInt val
        # console.log quantity
        Docs.update FlowRouter.getParam('doc_id'),
            $set: quantity: quantity
            
            
Template.edit_title.events
    'blur #title': (e,t)->
        title = $(e.currentTarget).closest('#title').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: title: title
            
Template.field_type.events
    'blur #field_type': (e,t)->
        field_type = $(e.currentTarget).closest('#field_type').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: field_type: field_type
            
            
Template.edit_slug.events
    'blur #slug': (e,t)->
        slug = $(e.currentTarget).closest('#slug').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: slug: slug
            
            
Template.plural_slug.events
    'blur #plural_slug': (e,t)->
        plural_slug = $(e.currentTarget).closest('#plural_slug').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: plural_slug: plural_slug
            
            
Template.edit_text.events
    'blur #text': (e,t)->
        text = $(e.currentTarget).closest('#text').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: text: text
            
Template.edit_type.events
    'blur #type': (e,t)->
        type = $(e.currentTarget).closest('#type').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: type: type
            
Template.edit_child_type.events
    'blur #child_type': (e,t)->
        child_type = $(e.currentTarget).closest('#child_type').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: child_type: child_type
            
            
Template.edit_link.events
    'blur #link': (e,t)->
        link = $(e.currentTarget).closest('#link').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: link: link
            
            
Template.page_name.events
    'blur #name': (e,t)->
        name = $(e.currentTarget).closest('#name').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: name: name
            
            
Template.type.events
    'blur #type': (e,t)->
        type = $(e.currentTarget).closest('#type').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: type: type
            
            
Template.edit_parent_id.events
    'blur #parent_id': (e,t)->
        parent_id = $(e.currentTarget).closest('#parent_id').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: parent_id
            
            
Template.edit_image_id.events
    "change input[type='file']": (e) ->
        doc_id = FlowRouter.getParam('doc_id')
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
                    Docs.update doc_id, $set: image_id: res.public_id
                return

    'keydown #input_image_id': (e,t)->
        if e.which is 13
            doc_id = FlowRouter.getParam('doc_id')
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
            Meteor.call "c.delete_by_public_id", @image_id, (err,res) =>
                if not err
                    # Do Stuff with res
                    # console.log res
                    # console.log @image_id, FlowRouter.getParam('doc_id')
                    Docs.update FlowRouter.getParam('doc_id'), 
                        $unset: 
                            image_id: 1

                else
                    throw new Meteor.Error "it failed miserably"


Template.edit_banner_image_id.events
    "change input[type='file']": (e) ->
        doc_id = FlowRouter.getParam('doc_id')
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
                    Docs.update doc_id, $set: banner_image_id: res.public_id
                return

    'keydown #input_banner_image_id': (e,t)->
        if e.which is 13
            doc_id = FlowRouter.getParam('doc_id')
            banner_image_id = $('#input_banner_image_id').val().toLowerCase().trim()
            if banner_image_id.length > 0
                Docs.update doc_id,
                    $set: banner_image_id: banner_image_id
                $('#input_banner_image_id').val('')



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
            Meteor.call "c.delete_by_public_id", @banner_image_id, (err,res) =>
                if not err
                    # Do Stuff with res
                    # console.log res
                    # console.log @banner_image_id, FlowRouter.getParam('doc_id')
                    Docs.update FlowRouter.getParam('doc_id'), 
                        $unset: 
                            banner_image_id: 1

                else
                    throw new Meteor.Error "it failed miserably"

Template.edit_image_url.events
    'click #remove_image_url': ->
        Docs.update FlowRouter.getParam('doc_id'), 
            $unset: 
                image_url: 1
        
    'blur #image_url': ->
        image_url = $('#image_url').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: image_url: image_url


            
Template.location.events
    'change #location': ->
        doc_id = FlowRouter.getParam('doc_id')
        location = $('#location').val()

        Docs.update doc_id,
            $set: location: location

Template.edit_content.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        # snippet = $('#snippet').val()
        # if snippet.length is 0
        #     snippet = $(html).text().substr(0, 300).concat('...')
        doc_id = FlowRouter.getParam('doc_id')

        Docs.update doc_id,
            $set: content: html
                

Template.edit_content.helpers
    getFEContext: ->
        @current_doc = Docs.findOne FlowRouter.getParam 'doc_id'
        self = @
        {
            _value: self.current_doc.content
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                  'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                  'selectAll'
                  'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                  'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            toolbarButtonsMD: ['bold', 'italic', 'underline']
            toolbarButtonsSM: ['bold', 'italic', 'underline']
            toolbarButtonsXS: ['bold', 'italic', 'underline']
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }

Template.edit_transcript.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        doc_id = FlowRouter.getParam('doc_id')

        Docs.update doc_id,
            $set: transcript: html
                

Template.edit_transcript.helpers
    transcript_context: ->
        @current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        self = @
        {
            _value: self.current_doc.transcript
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                #   'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                  'selectAll'
                  'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                  'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }


Template.edit_youtube.events
    'blur #youtube': (e,t)->
        youtube = $(e.currentTarget).closest('#youtube').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: youtube: youtube
            
    'click #clear_youtube': (e,t)->
        $(e.currentTarget).closest('#youtube').val('')
        Docs.update FlowRouter.getParam('doc_id'),
            $unset: youtube: 1
            
Template.edit_youtube.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000

Template.view_youtube.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000


Template.participants.onCreated ->
    Meteor.subscribe 'usernames'

Template.participants.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update FlowRouter.getParam('doc_id'),
            $addToSet: participant_ids: doc._id
        $('#participant_select').val("")
   
    'click #remove_participant': (e,t)->
        # console.log @
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: participant_ids: FlowRouter.getParam('doc_id')



Template.participants.helpers
    participants_edit_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }

    participants: ->
        participants = []
        
        for participant_id in @participant_ids
            participants.push Meteor.users.findOne(participant_id)
        participants

# Template.datetime.onRendered ->
#     Meteor.setTimeout (->
#         $('#datetimepicker').datetimepicker(
#             onChangeDateTime: (dp,$input)->
#                 val = $input.val()

#                 # console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
#                 minute = moment(val).minute()
#                 hour = moment(val).format('h')
#                 date = moment(val).format('Do')
#                 ampm = moment(val).format('a')
#                 weekdaynum = moment(val).isoWeekday()
#                 weekday = moment().isoWeekday(weekdaynum).format('dddd')

#                 month = moment(val).format('MMMM')
#                 year = moment(val).format('YYYY')

#                 datearray = [hour, minute, ampm, weekday, month, date, year]

#                 docid = FlowRouter.getParam 'docId'

#                 doc = Docs.findOne docid
#                 tagsWithoutDate = _.difference(doc.tags, doc.datearray)
#                 tagsWithNew = _.union(tagsWithoutDate, datearray)

#                 Docs.update docid,
#                     $set:
#                         tags: tagsWithNew
#                         datearray: datearray
#                         dateTime: val
#             )), 2000

# Template.location.onRendered ->
#     @autorun ->
#         if GoogleMaps.loaded()
#             $('#place').geocomplete().bind 'geocode:result', (event, result) ->
#                 docid = Session.get 'editing'
#                 Meteor.call 'updatelocation', docid, result, ->

# Template.location.events
#     'click .clearDT': ->
#         tagsWithoutDate = _.difference(@tags, @datearray)
#         Docs.update FlowRouter.getParam('docId'),
#             $set:
#                 tags: tagsWithoutDate
#                 datearray: []
#                 dateTime: null
#         $('#datetimepicker').val('')




#     'click #analyzeBody': ->
#         Docs.update FlowRouter.getParam('docId'),
#             $set: body: $('#body').val()
#         Meteor.call 'analyze', FlowRouter.getParam('docId')

#     'click .docKeyword': ->
#         docId = FlowRouter.getParam('docId')
#         doc = Docs.findOne docId
#         loweredTag = @text.toLowerCase()
#         if @text in doc.tags
#             Docs.update FlowRouter.getParam('docId'), $pull: tags: loweredTag
#         else
#             Docs.update FlowRouter.getParam('docId'), $push: tags: loweredTag

#     docKeywordClass: ->
#         docId = FlowRouter.getParam('docId')
#         doc = Docs.findOne docId
#         if @text.toLowerCase() in doc.tags then 'disabled' else ''


Template.edit_author.onCreated ->
    Meteor.subscribe 'usernames'

Template.edit_author.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        if confirm 'Change author?'
            Docs.update FlowRouter.getParam('doc_id'),
                $set: author_id: doc._id
            $('#author_select').val("")



Template.edit_author.helpers
    author_edit_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }

    # edit_author: ->
    #     participants = []
        
    #     for participant_id in @participant_ids
    #         participants.push Meteor.users.findOne(participant_id)
    #     participants
Template.edit_recipient.onCreated ->
    Meteor.subscribe 'usernames'

Template.edit_recipient.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update FlowRouter.getParam('doc_id'),
            $set: recipient_id: doc._id
        $('#recipient_select').val("")


Template.edit_recipient.helpers
    recipient_select_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }

    # edit_participant: ->
    #     participants = []
        
    #     for participant_id in @participant_ids
    #         participants.push Meteor.users.findOne(participant_id)
    #     participants


Template.start_date.events
    'blur #start_date': ->
        start_date = $('#start_date').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: start_date: start_date
    
Template.end_date.events
    'blur #end_date': ->
        end_date = $('#end_date').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: end_date: end_date

Template.time_marker.events
    'blur #time_marker': ->
        time_marker = parseFloat $('#time_marker').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: time_marker: time_marker


Template.remove_field.events
    'click .remove_field':  ->
        # console.log @slug
        self = @
        swal {
            title: "Remove #{@slug} field?"
            type: 'warning'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            parent_doc = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.update parent_doc._id, 
                $unset: 
                    "#{self.slug}": 1
            # swal("#{self.field} removed", "", "success")
            swal {
                title: "Removed #{self.slug} field."
                type: 'success'
                animation: false
                showCancelButton: false
                closeOnConfirm: true
                # cancelButtonText: 'Cancel'
                confirmButtonText: 'Ok'
                # confirmButtonColor: '#da5347'
            }
            
            
    
Template.view_transcript.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
Template.edit_transcript.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
            
Template.start_datetime.events
    'blur #start_datetime': ->
        start_datetime = $('#start_datetime').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: start_datetime: start_datetime


Template.end_datetime.events
    'blur #end_datetime': ->
        end_datetime = $('#end_datetime').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: end_datetime: end_datetime
