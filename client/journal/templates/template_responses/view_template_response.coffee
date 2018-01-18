Template.view_template_response.onCreated ->
    @autorun => Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    response_doc = Docs.findOne(FlowRouter.getParam('doc_id'))
        # parent_template = Docs.findOne(response_doc.parent_id)
    if response_doc
        @autorun => Meteor.subscribe 'child_docs', response_doc.parent_id

Template.view_journal_template_section.onCreated ->
    # console.log @data
    @autorun => Meteor.subscribe 'child_docs', @data._id

Template.view_template_response.events
    'click #delete_doc': ->
        if confirm 'Delete this journal template response?'
            Docs.remove @_id
            FlowRouter.go '/journal/templates'

    'click .create_section_response': ->
        Docs.insert
            type: 'template_section_response'
            parent_id: @_id
                
    'click .remove_section': ->
        console.log @
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: sections: @
                
    'blur .section_title': (e,t)->
        section_title = $(e.currentTarget).closest('.section_title').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $push:
                sections: new_section
        
                
Template.view_template_response.helpers
    journal_template: -> 
        response_doc = Docs.findOne(FlowRouter.getParam('doc_id'))
        parent_template = Docs.findOne(response_doc.parent_id)
    
    view_journal_template_sections: ->
        response_doc = Docs.findOne(FlowRouter.getParam('doc_id'))
        parent_template = Docs.findOne(response_doc.parent_id)
        Docs.find {
            type: 'journal_template_section'
            parent_id: parent_template._id
            }, sort: number: 1
            
Template.view_journal_template_section.helpers
    section_responses: ->
        Docs.find {
            type: 'template_section_response'
            parent_id: @_id
            group_id: FlowRouter.getParam('doc_id')
            }
        