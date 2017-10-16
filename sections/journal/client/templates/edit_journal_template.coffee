Template.edit_journal_template.onCreated ->
    @autorun => Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')


Template.edit_journal_template.events
    'click #delete_doc': ->
        if confirm 'Delete this journal template?'
            Docs.remove @_id
            FlowRouter.go '/journal'

    'click #add_section': ->
        Docs.insert
            type: 'journal_template_section'
            title: 'New Section'
            parent_id: FlowRouter.getParam('doc_id')
                
    'click .remove_section': ->
        console.log @
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: sections: @
                
    'blur .section_title': (e,t)->
        section_title = $(e.currentTarget).closest('.section_title').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $push:
                sections: new_section
        
                
Template.edit_journal_template.helpers
    journal_template: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    journal_template_sections: ->
        Docs.find {
            type: 'journal_template_section'
            parent_id: FlowRouter.getParam('doc_id')
            }, sort: number: 1