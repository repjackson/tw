FlowRouter.route '/course/:course_id/module/:doc_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_module'

if Meteor.isClient
    Template.edit_module.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('doc_id')
        # @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('course_id')
        # @autorun -> Meteor.subscribe 'module_sections', FlowRouter.getParam('course_id')
    
    Template.edit_module.onRendered ->
        Meteor.setTimeout ->
            $('.tabular.menu .item').tab()
        , 2000
        
    Template.edit_module.helpers
        module: -> Docs.findOne FlowRouter.getParam('doc_id')
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        
        sections: ->
            Docs.find
                type:'section'
                module_id: FlowRouter.getParam('doc_id')
            
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
                    
        'click #add_section': ->
            module_id = FlowRouter.getParam('doc_id')
            Docs.insert
                type:'section'
                module_id: module_id
                

if Meteor.isServer
    
    publishComposite 'module', (module_id)->
        {
            find: ->
                Docs.find module_id
            children: [
                { find: (module) ->
                    Docs.find
                        type: 'section'
                        module_id: module_id
                }
                {
                    find: (module) ->
                        Docs.find module.course_id
                }
            ]
        }