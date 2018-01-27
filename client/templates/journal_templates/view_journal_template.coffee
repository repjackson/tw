Template.view_journal_template.onCreated ->
    @autorun => Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')



Template.view_journal_template.onCreated ->
    Meteor.setTimeout ->
        $('.progress').progress()
    , 2000

Template.view_journal_template.helpers
    journal_template: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    journal_template_sections: ->
        Docs.find {
            type: 'journal_template_section'
            parent_id: FlowRouter.getParam('doc_id')
            }, sort: number: 1
            
            
Template.view_journal_template.events
    'click #create_response': ->
        new_response_id = Docs.insert
            type: 'template_response'
            parent_id: FlowRouter.getParam('doc_id')
            
        FlowRouter.go "/edit/#{new_response_id}"    
        

Template.template_responses.helpers
    template_responses: ->
        Docs.find
            parent_id: FlowRouter.getParam('doc_id')
            type: 'template_response'