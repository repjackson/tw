Template.username_filter.onCreated ->
    @autorun => 
        Meteor.subscribe('author_ids', 
            selected_tags.array()
            selected_author_ids.array()
            type=Template.currentData().type
            )
        Meteor.subscribe 'usernames'



Template.username_filter.helpers
    author_tags: ->
        author_usernames = []
        
        for author_id in Author_ids.find().fetch()
            found_user = Meteor.users.findOne(author_id.text).username
            # if found_user
                # console.log Meteor.users.findOne(author_id.text).username
            author_usernames.push Meteor.users.findOne(author_id.text).username
        author_usernames


    selected_author_ids: ->
        selected_author_usernames = []
        for selected_author_id in selected_author_ids.array()
            selected_author_usernames.push Meteor.users.findOne(selected_author_id).username
        selected_author_usernames
    
    
Template.username_filter.events
    'click .select_author': ->
        selected_author = Meteor.users.findOne username: @valueOf()
        selected_author_ids.push selected_author._id
    'click .unselect_author': -> 
        selected_author = Meteor.users.findOne username: @valueOf()
        selected_author_ids.remove selected_author._id
    'click #clear_authors': -> selected_author_ids.clear()

