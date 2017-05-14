if Meteor.isClient
    FlowRouter.route '/course/sol/module/:module_number/sections', 
        name: 'sections'
        action: (params) ->
            BlazeLayout.render 'doc_module',
                module_content: 'sections'
    
    Template.sections.onCreated ->
        @autorun -> Meteor.subscribe 'sections', parseInt FlowRouter.getParam('module_number')
    Template.section.onCreated ->
        @editing = new ReactiveVar(false)

    Template.section.helpers
        editing: -> Template.instance().editing.get()

    Template.sections.helpers
        sections: ->
            Docs.find {
                tags: $all: ['section'] },
                sort: number: 1
                
    Template.sections.events
        'click #add_section': ->
            module_number = parseInt FlowRouter.getParam('module_number')
            Docs.insert
                tags: ['section']
                module_number: module_number
                
    Template.section.events
        'click .edit_this': (e,t)-> 
            # console.log t.editing
            t.editing.set true
        'click .save_doc': (e,t)-> 
            # console.log t.editing
            t.editing.set false
        
                
                
if Meteor.isServer
    Meteor.publish 'sections', (module_number)->
        Docs.find 
            tags: $all: ['section']
            module_number: module_number