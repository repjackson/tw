@Sections = new Meteor.Collection 'sections'

Sections.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Sections.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()


if Meteor.isClient
    Template.edit_section.helpers
        section_content: ->
            @current_doc = Sections.findOne @_id
            self = @
            {
                _value: self.current_doc.section_content
                _keepMarkers: true
                _className: 'froala-reactive-meteorized-override'
                toolbarInline: false
                initOnClick: false
                imageInsertButtons: ['imageByURL']
                tabSpaces: false
                height: 300
            }
        
    Template.section_transcript.helpers
        transcript: ->
            @current_doc = Sections.findOne @_id
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
        
            
    Template.edit_section.events
        'blur #number': (e,t)->
            number = parseInt t.$('#number').val()
            Sections.update @_id,
                $set:
                    number:number

    
        'blur .section_content': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
    
            Sections.update @_id,
                $set: section_content: html

    Template.section_transcript.events
        'blur .transcript': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            Sections.update @_id,
                $set: transcript: html

    
if Meteor.isServer
    Sections.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    