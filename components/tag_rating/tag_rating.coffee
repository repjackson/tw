if Meteor.isClient
    Template.tag_rating.onCreated ->
        # console.log @data._id
        @autorun => Meteor.subscribe('article_tags', @data._id)
    
    Template.tag_rating.helpers
        ratings: ->
            Docs.find
                type: 'tag_rating'
                parent_id: @_id
    
        has_rated: ->
            # console.log @
            Docs.findOne 
                type: 'tag_rating'
                parent_id: @_id 

    Template.tag_rating.events
        'click #add_rating': ->
            Docs.insert 
                type: 'tag_rating'
                parent_id: @_id 
                
            

if Meteor.isServer
    Meteor.publish 'article_tags', (doc_id)->
        Docs.find
            type: 'tag_rating'
            parent_id: doc_id