FlowRouter.route '/journal/prompts', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'journal_prompts'

Template.journal_prompts.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='lightbank'
            author_id=null
            parent_id=null
            tag_limit=20
            doc_limit=Session.get 'doc_limit'
            view_published = true
            view_read = null
            view_bookmarked=Session.get('view_bookmarked')
            view_resonates = null
            view_complete = null
            view_images = null
            view_lightbank_type = 'journal_prompt'

            )
            

Template.journal_prompts.helpers
    journal_prompts: -> 
        match = {}
        match.type = 'lightbank'
        # match.tags = 
        Docs.find match, 
            sort:
                timestamp: -1
            limit: 5

    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

        
    journal_card_class: -> if @published then 'blue' else ''
    