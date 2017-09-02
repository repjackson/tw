if Meteor.isClient
    Template.person_tags.onCreated ->
        @autorun => Meteor.subscribe('person_tags', FlowRouter.getParam('username'))
        @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('username'))

    Template.person_tags.helpers
        person_tag_ratings: ->
            person = Meteor.users.findOne username: FlowRouter.getParam 'username'
            Docs.find
                type: 'person_tags'
                parent_user_id: person._id

        person: -> Meteor.users.findOne username: FlowRouter.getParam 'username'

        is_person: -> Meteor.user().username is FlowRouter.getParam 'username'


        my_rating: ->
            # console.log @
            my_rating = Docs.findOne 
                type: 'person_tags'
                parent_user_id: @_id 
                author_id: Meteor.userId()
            # if my_rating then console.log my_rating
            my_rating

    Template.person_tags.events
        'click #add_person_tags': ->
            person = Meteor.users.findOne username: FlowRouter.getParam 'username'
            new_person_tags_id = Docs.insert 
                type: 'person_tags'
                parent_user_id: person._id 
            Session.set 'editing_id', new_person_tags_id    



if Meteor.isServer
    Meteor.publish 'person_tags', (username)->
        user = Meteor.users.findOne username: username
        Docs.find
            type: 'person_tags'
            parent_user_id: user._id