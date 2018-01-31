if Meteor.isClient
    Template.view_sections.onCreated ->
        @autorun -> Meteor.subscribe 'usernames'
        @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    
    Template.view_section.onCreated ->
        @autorun -> Meteor.subscribe 'usernames'
        @autorun -> Meteor.subscribe 'child_docs'
    
    
    Template.edit_section.onRendered ->
        Meteor.setTimeout =>
            $('.menu .item').tab()
        , 1000
    
                
    Template.view_sections.events
        'click #add_section': ->
            id = Docs.insert
                type: 'section'
            FlowRouter.go "/edit/#{id}"
            
    Template.view_section.events
    
    Template.view_section.helpers
        section: -> Docs.findOne FlowRouter.getParam('doc_id')
        
        
            
            