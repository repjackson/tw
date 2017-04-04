@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    return


Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
), fetchPrevious: true


Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

FlowRouter.route '/lightbank', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'docs'

Meteor.methods
    add: (tags=[])->
        id = Docs.insert {}
        return id


if Meteor.isClient
    Template.docs.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array())

    Template.docs.helpers
        docs: -> 
            Docs.find { }, 
                sort:
                    tag_count: 1
                limit: 1
    
        one_doc: -> 
            Docs.find().count() is 1
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'

        selected_tags: -> selected_tags.array()

    
    Template.doc_view.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'
    
        when: -> moment(@timestamp).fromNow()

    Template.doc_view.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
    
        'click .edit': -> FlowRouter.go("/doc/edit/#{@_id}")

    Template.docs.events
    

if Meteor.isServer
    Docs.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    Meteor.publish 'docs', (selected_tags=[], type)->
    
        self = @
        match = {}
        # match.tags = $all: selected_tags
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        if type then match.type = type


        Docs.find match,
            limit: 3
            
    
    Meteor.publish 'doc', (id)->
        Docs.find id
    
    
    
