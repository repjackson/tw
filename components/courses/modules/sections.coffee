if Meteor.isClient
    Template.section_transcript.helpers
        transcript: ->
            @current_doc = Docs.findOne @_id
            self = @
            {
                _value: self.current_doc.transcript
                _keepMarkers: true
                _className: 'froala-reactive-meteorized-override'
                toolbarInline: false
                initOnClick: false
                imageInsertButtons: ['imageByURL']
                tabSpaces: false
                height: 300
            }
        
            
    Template.section_transcript.events
        'blur .transcript': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            Docs.update @_id,
                $set: transcript: html
                