if Meteor.isClient
    Template.view_modules.onCreated ->
        @autorun -> Meteor.subscribe 'usernames'
        @autorun -> Meteor.subscribe 'modules'
    
    Template.view_module.onCreated ->
        @autorun -> Meteor.subscribe 'child_docs'
    
    Template.view_module.onRendered ->
        Meteor.setTimeout =>
            $('.menu .item').tab()
        , 1000
    
    Template.edit_module.onRendered ->
        Meteor.setTimeout =>
            $('.menu .item').tab()
        , 1000
    
    Template.view_modules.helpers
        modules: -> Docs.find {type: 'module'}, sort: number:1
    
    
                
    Template.view_modules.events
        'click #add_module': ->
            id = Docs.insert
                type: 'module'
            FlowRouter.go "/edit/#{id}"
            
            
    
    Template.view_module.helpers
        module: -> Docs.findOne FlowRouter.getParam('doc_id')
        
        background_style: -> "background-image:url('https://res.cloudinary.com/facet/image/upload/c_fit,w_500/rczjotzxkirmg4g83axa')"
        
        sales: ->
            module=Docs.findOne FlowRouter.getParam('doc_id')
            sales = Docs.findOne {parent_id:module._id, type:'module_sales'}
        
        
    Template.section_list.onCreated ->
        @autorun -> Meteor.subscribe 'module_modules', FlowRouter.getParam('doc_id')
        
    Template.section_list.helpers
        sections: ->
            module = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.find {parent_id: module._id}, sort:number:1

        
        
        
    Template.edit_module.helpers
        module: -> Docs.findOne FlowRouter.getParam('doc_id')
        
        
    Template.edit_module.events
        'click #delete_module': ->
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
                module = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.remove module._id, ->
                    FlowRouter.go "/modules"        
                    