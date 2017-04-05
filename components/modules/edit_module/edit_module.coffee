FlowRouter.route '/course/:course_id/module/:doc_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_module'

if Meteor.isClient
    Template.edit_module.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('course_id')
    
    
    Template.edit_module.helpers
        module: -> Docs.findOne FlowRouter.getParam('doc_id')
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        
        
            
    Template.edit_module.events
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
                    FlowRouter.go "/course/view/#{course_id}"