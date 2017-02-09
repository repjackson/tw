@Modules = new Meteor.Collection 'modules'


FlowRouter.route '/modules', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'modules'

Meteor.methods
    add: ()->
        id = Modules.insert
        return id


if Meteor.isClient
    Template.modules.onCreated -> 
        @autorun -> Meteor.subscribe('modules')

    Template.modules.helpers
        modules: -> 
            Modules.find { }
    

    

    Template.view.events
    
        'click .edit': -> FlowRouter.go("/edit/#{@_id}")

    Template.modules.events
        'click #add': ->
            Meteor.call 'add', (err,id)->
                FlowRouter.go "/edit_module/#{id}"
    
    


if Meteor.isServer
    Modules.allow
        insert: (userId, doc) -> doc.author_id is userId
        update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'modules', ()->
    
        self = @
        match = {}
        # selected_tags.push current_herd
        # match.tags = $all: selected_tags
        # if selected_tags.length > 0 then match.tags = $all: selected_tags

        

        Modules.find match
    
    Meteor.publish 'module', (id)->
        Modules.find id
    
