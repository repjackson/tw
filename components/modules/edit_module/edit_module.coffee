FlowRouter.route '/course/:course_id/module/:module_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_module'

if Meteor.isClient
    Template.edit_module.onCreated ->
        @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')
    
    Template.edit_module.onRendered ->
        Meteor.setTimeout ->
            $('.tabular.menu .item').tab()
        , 2000
        
        
        
    Template.edit_module.helpers
        module: -> Modules.findOne FlowRouter.getParam('module_id')
        course: -> Courses.findOne FlowRouter.getParam('course_id')
        
        sections: ->
            Sections.find
                module_id: FlowRouter.getParam('module_id')
            
    Template.edit_module.events
        'click #save_module': ->
            title = $('#title').val()
            number = parseInt $('#number').val()
            course_id = FlowRouter.getParam('course_id')
            Modules.update module_id,
                $set:
                    title:title
                    number:number
            FlowRouter.go "/module/#{module_id}"        
    
    
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
                module = Modules.findOne FlowRouter.getParam('module_id')
                Modules.remove module._id, ->
                    FlowRouter.go "/course/#{course_id}"
                    
        'click #add_section': ->
            module_id = FlowRouter.getParam('module_id')
            
            module = Modules.findOne module_id
            
            Modules.update module_id,
                $inc: section_count: 1

            section_number = module.section_count + 1
            
            Sections.insert
                number: section_number
                module_id: module_id

            $('.tabular.menu .item').tab()
                
                
        'click .remove_section': ->
            self = @
            swal {
                title: "Delete Section #{self.number}?"
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Modules.remove self._id
                
