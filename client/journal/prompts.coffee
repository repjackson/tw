FlowRouter.route '/journal/prompts', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'journal_prompts'

Template.view_journal_prompts.onCreated -> 
    selected_theme_tags.clear()
    selected_author_ids.clear()
    selected_location_tags.clear()
    selected_intention_tags.clear()
    selected_timestamp_tags.clear()

    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='journal_prompt'
            author_id=null
            parent_id=null
            tag_limit = 20
            doc_limit = 20
            view_published = true
            view_read = null
            view_bookmarked=Session.get('view_bookmarked')
            view_resonates = null
            view_complete = null
            view_images = null

            )
            

Template.view_journal_prompts.helpers
    journal_prompts: -> 
        match = {}
        match.type = 'journal_prompt'
        # match.tags = 
        Docs.find match, 
            sort:
                timestamp: -1
            limit: 5

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

        
    journal_card_class: -> if @published then 'blue' else ''
    
Template.response_list.onCreated ->
    @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')

Template.response_list.helpers
    responses: ->
        doc_id = FlowRouter.getParam('doc_id')
        Docs.find
            parent_id: doc_id
