FlowRouter.route '/course/:slug/module/:module_number/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_module'

Template.edit_module.onCreated ->
    @autorun -> Meteor.subscribe 'module', course=FlowRouter.getParam('slug'), module_number=parseInt FlowRouter.getParam('module_number')

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
        module_number = parseInt FlowRouter.getParam('module_number')

        Docs.findOne
            type: 'module'
            number: module_number
    course: -> Docs.findOne slug:FlowRouter.getParam('slug')
    
    sections: ->
        module_number = parseInt FlowRouter.getParam('module_number')

        Docs.find {
            type: 'section'
            module_number: module_number
        }, sort: number: 1
        
Template.edit_module.events
    'click #save_module': ->
        FlowRouter.go "/course/sol/module/#{module_number}"        


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
                Docs.findOne 
                    type: 'module'
                    number:FlowRouter.getParam('module_number')
            Docs.remove module._id, ->
                FlowRouter.go "/course/#{slug}"
                
    'click #add_section': ->
        module_number = parseInt FlowRouter.getParam('module_number')
        
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
