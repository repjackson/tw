Template.tag_ratings.onCreated ->
    @autorun => Meteor.subscribe('document_tags', @data._id)

Template.tag_ratings.helpers
    ratings: ->
        Docs.find
            type: 'tag_rating'
            parent_id: @_id
    
    person: -> Meteor.users.findOne username:FlowRouter.getParam('username') 

Template.tag_rate.helpers
    my_rating: ->
        # console.log @
        my_rating = Docs.findOne 
            type: 'tag_rating'
            parent_id: @_id 
        # if my_rating then console.log my_rating
        my_rating

Template.tag_rate.events
    'click #add_rating': ->
        new_rating_id = Docs.insert 
            type: 'tag_rating'
            parent_id: @_id 
        Session.set 'editing_id', new_rating_id    

