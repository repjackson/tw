if Meteor.isClient
    FlowRouter.route '/facet', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'facet'


    Template.doc_content.onCreated ->
        @autorun => Meteor.subscribe 'facet_doc', @data.tags 
        
        
    Template.doc_body.onCreated ->
        @autorun => Meteor.subscribe 'facet_doc', @data.tags 
        
        
    Template.doc_content.helpers
        doc: ->
            tags = Template.currentData().tags
            split_array = tags.split ','

            Docs.findOne
                tags: split_array
    
        template_tags: ->
            Template.currentData().tags
    
        doc_classes: ->
            Template.parentData().classes

    
    Template.doc_body.helpers
        doc: ->
            tags = Template.currentData().tags
            split_array = tags.split ','

            Docs.findOne
                tags: split_array
    
        template_tags: ->
            Template.currentData().tags
    
        doc_classes: ->
            Template.parentData().classes

    
    
    Template.doc_content.events
        'click .edit_content': ->
            Session.set 'editing_id', @_id

        'click .create_doc': (e,t)->
            tags = t.data.tags
            split_array = tags.split ','
            new_id = Docs.insert
                tags: split_array
            Session.set 'editing_id', new_id

            
    Template.doc_body.events
        'click .edit_content': ->
            Session.set 'editing_id', @_id

        'click .create_doc': (e,t)->
            tags = t.data.tags
            split_array = tags.split ','
            new_id = Docs.insert
                tags: split_array
            Session.set 'editing_id', new_id

            
    Template.edit_content.helpers
        edit_doc_context: ->
            @current_doc = Docs.findOne @_id 
            self = @
            {
                _value: self.current_doc.content
                _keepMarkers: true
                _className: 'froala-reactive-meteorized-override'
                toolbarInline: false
                initOnClick: false
                imageInsertButtons: ['imageBack', '|', 'imageByURL']
                tabSpaces: false
                height: 300
            }

    
    Template.edit_content.events            
        'blur .froala-container': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            Docs.update @_id,
                $set: content: html
                
        'click .save_content': ->
            Session.set 'editing_id', null
            
            
            
    Template.thing.events        
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
                
        'keyup #body': (e,t)->
            if e.which is 13
                body = $(e.currentTarget).closest('#body').val()
                Docs.update @_id,
                    $set: body: body
                Session.set 'editing_id', null
                            
            
    Template.edit_body.events            
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            
        'click .save_content': ->
            Session.set 'editing_id', null
            
            
            
            
if Meteor.isServer
    Meteor.publish 'facet_doc', (tags)->
        split_array = tags.split ','
        Docs.find
            tags: split_array