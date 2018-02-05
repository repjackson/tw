@selected_parent_tags = new ReactiveArray []

Template.parent_facet.helpers
    available_parent_docs: ->
        available_parent_docs = []
        
        for parent_id in Parent_ids.find().fetch()
            parent_doc = Docs.findOne parent_id.doc_id
            available_parent_docs.push parent_doc
        available_parent_docs

    selected_parent_docs: -> 
        selected_parent_ids = []
        for selected_parent_id in selected_author_ids.array()
            selected_parent_docs.push Docs.findOne selected_parent_id
        selected_parent_tags.array()
    


Template.parent_facet.events
    'click .select_parent_tag': -> selected_parent_tags.push @doc_id
    'click .unselect_parent_tag': -> selected_parent_tags.remove @valueOf()
    'click #clear_parent_tags': -> selected_parent_tags.clear()

    'click .select_author': ->
        selected_author = Meteor.users.findOne username: @username
        selected_author_ids.push selected_author._id
    'click .unselect_author': -> 
        selected_author = Meteor.users.findOne username: @valueOf()
        selected_author_ids.remove selected_author._id
    'click #clear_authors': -> selected_author_ids.clear()
