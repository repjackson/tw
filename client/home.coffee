Template.home.onCreated ->
    # @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'ancestor_ids'
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    @autorun => Meteor.subscribe 'facet', 
        selected_theme_tags.array()
        selected_ancestor_ids.array()
        selected_author_ids.array()
        selected_location_tags.array()
        selected_intention_tags.array()
        selected_timestamp_tags.array()
        type = null
        author_id = null
        # parent_id = FlowRouter.getParam('doc_id')
        view_private = Session.get 'view_private'
        
