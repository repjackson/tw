if Meteor.isClient
    FlowRouter.route '/course/sol/module/:module_number/downloads', 
        name: 'downloads'
        action: (params) ->
            BlazeLayout.render 'view_module',
                module_content: 'downloads'
    
    
    
    Template.downloads.onCreated ->
        @autorun -> Meteor.subscribe 'module', parseInt FlowRouter.getParam('module_number')
    
    
    Template.downloads.helpers
        module: -> 
            Docs.findOne
                tags: $in: ["module"]
                number: parseInt FlowRouter.getParam('module_number')
                
        module_files: -> 
            Docs.find
                type: 'download'
                # parent_id: module_doc._id

    Template.downloads.events
        'click #add_file': (e,t)->
            module_number = FlowRouter.getParam('module_number')
            module_doc = Docs.findOne
                tags: $in: ["module"]
                number: parseInt FlowRouter.getParam('module_number')

            new_id = Docs.insert
                type: 'download'
                parent_id: module_doc._id
            Session.set 'editing_id', new_id

if Meteor.isServer
    Meteor.publish 'module_new_downloads', (module_id)->
        Docs.find
            type: 'download'
            parent_id: module_id