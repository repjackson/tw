FlowRouter.route '/journal', action: ->
    BlazeLayout.render 'layout', 
        main: 'journal'

Template.journal.onCreated ->
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

Template.journal.onCreated ->
    # @autorun -> Meteor.subscribe 'usernames'


Template.journal.helpers
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


            
Template.journal.events
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

        
Template.journal.events
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal'
        FlowRouter.go("/edit/#{new_journal_id}")    




