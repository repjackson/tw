if Meteor.isClient
    Template.doc_by_parentid_and_type.onCreated ->
        @editing = new ReactiveVar(false)
        # console.log @data.parent_id
        # console.log @data.type
        @autorun => Meteor.subscribe 'doc_by_parentid_and_type', @data.parent_id, @data.type
        
        
    Template.doc_by_parentid_and_type.helpers
        editing: -> Template.instance().editing.get()

        doc: -> 
            Docs.findOne
                type: Template.currentData().type
                parent_id: Template.currentData().parent_id
    
        doc_classes: -> Template.parentData().classes
        
        doc_parent_id: -> Template.currentData().parent_id
        
        doc_type: -> Template.currentData().type

    Template.doc_by_parentid_and_type.events
        'click .edit_this': (e,t)-> t.editing.set true
        'click .save_doc': (e,t)-> t.editing.set false

        'click .edit_content': ->
            Session.set 'editing_id', @_id

        'click .create_doc': (e,t)->
            #  if t.data.tags
            #     tags = t.data.tags
            #     tags = tags.split ','
            new_id = Docs.insert
                # tags: split_array
                type: t.data.type
                parent_id: t.data.parent_id
                content: ''
            Session.set 'editing_id', new_id

if Meteor.isServer
    Meteor.publish 'doc_by_parentid_and_type', (parent_id, type)->
        # console.log parent_id
        # console.log type
        Docs.find
            type: type
            parent_id: parent_id