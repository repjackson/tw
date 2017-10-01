FlowRouter.route '/journal/prompts', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'journal_prompts'

Template.journal_prompts.onCreated -> 
    self = @
    @autorun => 
        Meteor.subscribe('journal_prompts', 
            selected_tags.array()
            )
            

Template.journal_prompt.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500


Template.journal_prompts.helpers
    journal_prompts: -> 
        match = {}
        match.type = 'lightbank'
        # match.tags = 
        Docs.find match, 
            sort:
                timestamp: -1
            limit: 5

    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

        
    journal_card_class: -> if @published then 'blue' else ''
    

Template.journal_prompt.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    journal_card_class: -> if @published then 'blue' else ''

    read: -> Meteor.userId() in @read_by
    liked: -> Meteor.userId() in @liked_by
    
    read_count: -> @read_by.length    
    liked_count: -> @liked_by.length    


Template.journal_prompt.events
    'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())

    'click .mark_read': (e,t)-> 
        $(e.currentTarget).closest('.journal_segment').transition('pulse')
        Docs.update @_id, $addToSet: read_by: Meteor.userId()
        
    'click .mark_unread': (e,t)-> 
        $(e.currentTarget).closest('.journal_segment').transition('pulse')
        Docs.update @_id, $pull: read_by: Meteor.userId()





