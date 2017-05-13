if Meteor.isClient
    FlowRouter.route '/course/sol/module/:module_number/sections', 
        name: 'module_sections'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'module_sections'
    
    Template.module_sections.onCreated ->
        @autorun -> Meteor.subscribe 'module_sections', parseInt FlowRouter.getParam('module_number')
    Template.module_section.onCreated ->
        @editing = new ReactiveVar(false)

    Template.module_section.helpers
        editing: -> Template.instance().editing.get()

    Template.module_sections.helpers
        module_sections: ->
            Docs.find {
                tags: $all: ['section'] },
                sort: number: 1
                
    Template.module_sections.events
        'click #add_section': ->
            module_number = parseInt FlowRouter.getParam('module_number')
            Docs.insert
                tags: ['section']
                module_number: module_number
                
    Template.module_section.events
        'click .edit_this': (e,t)-> 
            # console.log t.editing
            t.editing.set true
        'click .save_doc': (e,t)-> 
            # console.log t.editing
            t.editing.set false
        
                
                
if Meteor.isServer
    Meteor.publish 'module_sections', (module_number)->
        Docs.find 
            tags: $all: ['section']
            module_number: module_number