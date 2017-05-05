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


if Meteor.isServer    
    publishComposite 'section', (course, module_number, section_number)->
        {
            find: ->
                Docs.find 
                    type: 'section'
                    course: course
                    module_number: module_number
                    section_number
            children: [
                {
                    find: (section) ->
                        Docs.find
                            section_id: section._id
                            type: 'question'
                    children: [
                        {
                            find: (question) ->
                                Docs.find 
                                    question_id: question._id
                                    type: 'answer'
                            }
                        ]
                    }
                
                ]
        }