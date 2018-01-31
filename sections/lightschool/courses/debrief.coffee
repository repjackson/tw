if Meteor.isClient
    Template.view_sections.onCreated ->
        @autorun -> Meteor.subscribe 'usernames'
        @autorun -> Meteor.subscribe 'sections'
    
    Template.view_section.onCreated ->
        @autorun -> Meteor.subscribe 'child_docs'
    
    Template.view_section.onRendered ->
        Meteor.setTimeout =>
            $('.menu .item').tab()
        , 1000
    Template.view_debrief.onRendered ->
        # Meteor.setTimeout ->
        #     $('.progress').progress()
        # , 2000
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 2000

    Template.edit_section.onRendered ->
        Meteor.setTimeout =>
            $('.menu .item').tab()
        , 1000
    
    Template.view_sections.helpers
        sections: -> Docs.find {type: 'section'}, sort: number:1
    
    
                
    Template.view_sections.events
        'click #add_section': ->
            id = Docs.insert
                type: 'section'
            FlowRouter.go "/edit/#{id}"
            
            
    
    Template.view_section.helpers
        section: -> Docs.findOne FlowRouter.getParam('doc_id')
        
        
        
        
    Template.edit_section.helpers
        section: -> Docs.findOne FlowRouter.getParam('doc_id')
        
        
    Template.edit_section.events
        'click #delete_section': ->
            swal {
                title: 'Delete check in?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                section = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.remove section._id, ->
                    FlowRouter.go "/sections"        
                    
                    
                    