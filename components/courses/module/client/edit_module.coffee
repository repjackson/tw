FlowRouter.route '/course/:course_slug/module/:module_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_module'

Template.edit_module.onCreated ->
    @autorun -> Meteor.subscribe 'module', FlowRouter.getParam('module_id')

Template.edit_module.onRendered ->
    self = @
    
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                # $('#section_tabs .item').tab()
                $('.ui.accordion').accordion()

            , 1000

    
    
    
Template.edit_module.helpers
    module: -> 
        module_id = FlowRouter.getParam('module_id')
        Modules.findOne module_id
    
    course: -> 
        
        Courses.findOne slug:FlowRouter.getParam('slug')
    
    sections: ->
        module_number = parseInt FlowRouter.getParam('module_id')

        Docs.find {
            type: 'section'
            module_number: module_number
        }, sort: number: 1
        
Template.edit_module.events
    'click #save_module': ->
        FlowRouter.go "/course/sol/module/#{module_number}"        
            
            
    'blur #title': (e,t)->
        title = $(e.currentTarget).closest('#title').val()
        Modules.update @_id,
            $set: title: title
            
    'blur #slug': (e,t)->
        slug = $(e.currentTarget).closest('#slug').val()
        Modules.update @_id,
            $set: slug: slug
            

    'blur #number': (e) ->
        val = $(e.currentTarget).closest('#number').val()
        number = parseInt val
        Modules.update @_id,
            $set: number: number

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
            module = 
                Modules.findOne 
                    number:FlowRouter.getParam('module_id')
            Docs.remove module._id, ->
                FlowRouter.go "/course/#{slug}"
                
    'click #add_section': ->
        module_number = parseInt FlowRouter.getParam('module_id')
        
        module =
            Docs.findOne 
                type: 'module'
                number:module_number
        
        Docs.update module_number,
            $inc: section_count: 1
            , ->
                section_number = module.section_count + 1
        
                Docs.insert
                    type: 'section'
                    number: section_number
                    module_number: module_number
                    lightwork:false

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
            module_id = FlowRouter.getParam('module_id')
            Docs.update module_id,
                $inc: section_count: -1

            Docs.remove self._id
            
Template.edit_section.events
    'click #make_lightwork': -> 
        Docs.update @_id, $set: "lightwork": true
    'click #unmake_lightwork': -> 
        Docs.update @_id, $set: "lightwork": false
