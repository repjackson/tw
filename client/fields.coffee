            
Template.plain.events
    'blur #plain': (e,t)->
        plain = $(e.currentTarget).closest('#plain').val()
        Docs.update @_id,
            $set: plain: plain
            
            
Template.tags.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update Template.currentData()._id,
            $addToSet: tags: doc.name
        Meteor.call 'calculate_tag_count', Template.currentData()._id

        $('#theme_tag_select').val('')
   
    'keyup #theme_tag_select': (e,t)->
        e.preventDefault()
        val = $('#theme_tag_select').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update Template.currentData()._id,
                        $addToSet: tags: val
                    $('#theme_tag_select').val ''
                    Meteor.call 'calculate_tag_count', Template.currentData()._id
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(Template.currentData()._id).tags.slice -1
            #         $('#theme_tag_select').val result[0]
            #         Docs.update Template.currentData()._id,
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: tags: tag
        $('#theme_tag_select').val(tag)
        
Template.tags.helpers
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
                matchAll: true
                template: Template.tag_pill
            }
            ]
    }


            
Template.number.events
    'blur #number': (e) ->
        # console.log @
        val = $(e.currentTarget).closest('#number').val()
        number = parseInt val
        # console.log number
        Docs.update @_id,
            $set: number: number
            
            
Template.body_field.events
    'blur #body_field': (e,t)->
        body_field = $(e.currentTarget).closest('#body_field').val()
        Docs.update @_id,
            $set: body: body_field
            
            
            
            
Template.edit_parent_id.events
    'blur #parent_id': (e,t)->
        parent_id = $(e.currentTarget).closest('#parent_id').val()
        Docs.update @_id,
            $set: parent_id: parent_id
            
            

Template.image_url.events
    'click #remove_image_url': ->
        Docs.update @_id, 
            $unset: 
                image_url: 1
        
    'blur #image_url': (e)->
        image_url = $(e.currentTarget).closest('#image_url').val()
        Docs.update @_id,
            $set: image_url: image_url


            

Template.content.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        # snippet = $('#snippet').val()
        # if snippet.length is 0
        #     snippet = $(html).text().substr(0, 300).concat('...')
        doc_id = @_id

        Docs.update doc_id,
            $set: content: html
                

Template.content.helpers
    getFEContext: ->
        @current_doc = Docs.findOne @_id
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

Template.child_view.helpers
    typed_children: ->
        parent_doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc_template = Docs.findOne type: 'doc_template'
        Docs.find
            parent_id: parent_doc._id
            type: doc_template.type