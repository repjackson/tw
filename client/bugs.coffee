FlowRouter.route '/bugs', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'bugs'

Template.bugs.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='bug_report'
            author_id=null
            parent_id=null
            tag_limit=null
            doc_limit=null
            view_published=null
            view_read=null
            view_bookmarked=null
            view_resonates=null
            view_complete=Session.get 'view_complete'
            )

    
Template.bug.onCreated ->
    Meteor.subscribe 'author', @data._id
    
Template.bugs.helpers
    bugs: ->
        Docs.find {
            type: 'bug_report'
        }, sort: timestamp: -1