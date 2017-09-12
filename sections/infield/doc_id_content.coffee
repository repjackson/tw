if Meteor.isClient
    Template.doc_id_content.onCreated ->
        @editing = new ReactiveVar(false)

        @autorun => Meteor.subscribe 'doc_by_id', @data.id 
        
        
    Template.doc_id_content.helpers
        editing: -> Template.instance().editing.get()

        doc: -> Docs.findOne Template.currentData().id
    
        doc_classes: -> Template.parentData().classes
        
        doc_parent_id: -> Template.parentData().parent_id
        
        doc_type: -> Template.parentData().type


    Template.doc_id_content.events
        'click .edit_this': (e,t)-> t.editing.set true
        'click .save_doc': (e,t)-> t.editing.set false

        'click .edit_content': ->
            Session.set 'editing_id', @_id

        'click .create_doc': (e,t)->
            #  if t.data.tags
            #     tags = t.data.tags
            #     tags = tags.split ','
            new_id = Docs.insert
                tags: split_array
                type: t.data.type
                parent_id: t.data.parent_id
            Session.set 'editing_id', new_id
