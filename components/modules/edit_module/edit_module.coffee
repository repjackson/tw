FlowRouter.route '/module/edit/:module_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_module'




if Meteor.isClient
    Template.edit_module.onCreated ->
        @autorun ->
            Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    Template.edit_module.helpers
        module: ->
            Docs.findOne FlowRouter.getParam('doc_id')
        
            
    Template.edit_module.events
        'click #save': ->
            FlowRouter.go "/module/view/#{@_id}"
    
    
        'blur #course': ->
            course = $('#course').val()
            Docs.update FlowRouter.getParam('doc_id'),
                $set: course: course
                
        'change #module_number': (e) ->
            module_number = $('#module_number').val()
            int = parseInt module_number
            module_id = FlowRouter.getParam('doc_id')
            Docs.update FlowRouter.getParam('doc_id'),
                $set: module_number: int
        
    
        'click #delete': ->
            swal {
                title: 'Delete?'
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