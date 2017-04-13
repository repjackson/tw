@Files = new Meteor.Collection 'files'

Files.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Files.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

if Meteor.isClient
    Session.setDefault 'editing_id', null
    
    Template.module_downloads.onCreated ->
        @autorun -> Meteor.subscribe 'module_files', FlowRouter.getParam('module_id')

    Template.module_downloads.helpers
        module: -> Modules.findOne FlowRouter.getParam('module_id')

        module_files: ->
            Files.find({})

    Template.module_downloads.events
        'click #add_file': (e,t)->
            module_id = FlowRouter.getParam('module_id')
            new_id = Files.insert
                module_id: module_id
            Session.set 'editing_id', new_id

    Template.file_item.events
        'click .edit_file': ->
            Session.set 'editing_id', @_id
    

if Meteor.isServer
    Files.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    publishComposite 'module_files', (module_id)->
        {
            find: ->
                Files.find module_id: module_id
            # children: [
            #     { find: (question) ->
            #         Answers.find
            #             question_id: question._id
            #     }
            # ]
        }