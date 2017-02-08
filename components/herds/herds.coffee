@Herds = new Meteor.Collection 'herds'


Herds.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.members = []
    
    return

Herds.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
), fetchPrevious: true


Herds.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()







if Meteor.isClient
    Template.herd_items.onCreated ->
        @autorun -> Meteor.subscribe('herds', selected_herd_tags.array())
    
    Template.herds.events
        'click #add_herd': ->
            id = Herds.insert {}
            FlowRouter.go "/edit_herd/#{id}"
    
    Template.herd_items.helpers
        herds: -> 
            Herds.find()
            

    Template.herd_item.helpers
        herd_tag_class: -> if @valueOf() in selected_herd_tags.array() then 'primary' else ''
    
    
if Meteor.isServer
    
    
    Herds.allow
        insert: (userId, doc) -> doc.author_id is userId
        update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    

    
    Meteor.publish 'herds', (selected_herd_tags)->
        match = {}
        if selected_herd_tags.length > 0 then match.tags = $all: selected_herd_tags

        Herds.find match
