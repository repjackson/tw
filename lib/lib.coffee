@Tags = new Meteor.Collection 'tags'
@Docs = new Meteor.Collection 'docs'

Meteor.methods
    add: (tags=[])->
        id = Docs.insert {}
        return id