FlowRouter.route '/journal', action: ->
    BlazeLayout.render 'layout', 
        main: 'journal'

Template.view_journal_section.onCreated ->
    @autorun => 
        Meteor.subscribe('new_facet', 
            selected_theme_tags.array()
            type = 'journal'
            parent_id = null
            tag_limit = 20
            doc_limit = 5

            )

Template.journal_card.onCreated ->
    # @autorun -> Meteor.subscribe 'usernames'

Template.view_journal_section.onCreated ->
    # @autorun -> Meteor.subscribe 'usernames'


Template.view_journal_section.helpers
    entries: -> 
        Docs.find {
            type: 'journal', 
            published: $in: [1,0]
            }

Template.journal_card.helpers
    theme_tag_class: -> if @valueOf() in selected_theme_tags.array() then 'blue' else 'basic'
    location_tag_class: -> if @valueOf() in selected_location_tags.array() then 'blue' else 'basic'

Template.journal_card.events
    'click .theme_tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())
    'click .location_tag': -> if @valueOf() in selected_location_tags.array() then selected_location_tags.remove(@valueOf()) else selected_location_tags.push(@valueOf())


            
Template.view_journal_section.events
    'click #add_entry': ->
        id = Docs.insert
            type: 'journal'
        FlowRouter.go "/journal/#{id}/edit"
        
    
    
        
FlowRouter.route '/journal/:doc_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_journal_entry'
        
        
FlowRouter.route '/journal/:doc_id/view', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_journal_entry'

Template.edit_journal_entry.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.edit_journal_entry.helpers
    journal_entry: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.view_journal_entry.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.view_journal_entry.helpers
    journal_entry: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.edit_journal_entry.events
    'click #delete_entry': ->
        swal {
            title: 'Delete journal entry?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            journal = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove journal._id, ->
                FlowRouter.go "/journal"        
                
                
                
FlowRouter.route '/journal/mine', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'my_journal'

Template.my_journal.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type='journal'
            author_id=Meteor.userId()
            parent_id=null
            tag_limit=20
            doc_limit=20
            view_published=null
            view_read=null
            view_bookmarked=false
            view_resonates=null
            view_complete=null
            view_images=null
            view_lightbank_type=null

            )
        
Template.journal.events
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal_entry'
        FlowRouter.go("/edit/#{new_journal_id}")    
Template.my_journal.events
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal_entry'
        FlowRouter.go("/edit/#{new_journal_id}")    

Template.my_entry_view.onCreated -> 
    # @autorun => Meteor.subscribe 'author', @data._id
    
    
Template.my_entry_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500


Template.my_journal.helpers
    journal_entries: -> 
        match = {}
        match.type = 'journal'
        Docs.find match, 
            sort:
                timestamp: -1


    journal_card_class: -> if @published then 'blue' else ''
    
    published_count: -> Counts.get('unread_journal_count')



Template.my_entry_view.helpers
    tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    journal_segment_class: -> if @published then 'green raised' else ''


Template.my_entry_view.events




FlowRouter.route '/journal/prompts', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'journal_prompts'

Template.journal_prompts.onCreated -> 
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
            tag_limit=20
            doc_limit=Session.get 'doc_limit'
            view_published = true
            view_read = null
            view_bookmarked=Session.get('view_bookmarked')
            view_resonates = null
            view_complete = null
            view_images = null

            )
            

Template.journal_prompts.helpers
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
    
