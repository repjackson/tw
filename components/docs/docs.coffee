@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    # doc.points = 0
    # doc.upvoters = []
    # doc.downvoters = []
    # doc.published = false
    return


Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
), fetchPrevious: true



Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    parent_doc: -> Docs.findOne @parent_id



Meteor.methods
    add: (tags=[])->
        id = Docs.insert {}
        return id


if Meteor.isClient
    Template.docs.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), type=null, 5)

    Template.docs.helpers
        docs: -> 
            Docs.find { }, 
                sort:
                    tag_count: 1
                limit: 10
    
        one_doc: -> 
            Docs.find().count() is 1
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

        selected_tags: -> selected_tags.array()

    
    FlowRouter.route '/view/:doc_id', 
        name: 'view'
        action: (params) ->
            BlazeLayout.render 'layout',
                main: 'doc_page'

    Template.doc_page.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.doc_page.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    

    
    
    
    
    

if Meteor.isServer
    Docs.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    Meteor.publish 'docs', (selected_tags, type, limit, view_mode)->
    
        self = @
        match = {}
        match.tags = $all: selected_tags
        # if selected_tags.length > 0 then match.tags = $all: selected_tags
        if type then match.type = type
        # console.log view_mode
        if view_mode and view_mode is 'mine'
            match.author_id
    
        if limit
            Docs.find match, 
                limit: limit
        else
            Docs.find match
    
    Meteor.publish 'doc', (id)->
        Docs.find id
    
    
    
