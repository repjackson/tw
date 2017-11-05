Template.q_a.helpers
    sessions: ->
        Docs.find
            parent_id: FlowRouter.getParam('doc_id')
            type: 'session'
    
    questions: ->
        Docs.find
            parent_id: FlowRouter.getParam('doc_id')
            type: $ne: 'session'


Template.journal_entry_view.onCreated -> 
    @autorun => Meteor.subscribe 'author', @data._id
    
 
Template.journal_entry_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500

Template.journal_entry_view.helpers
    # tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
    journal_card_class: -> if @published then 'blue' else ''


Template.sessions.helpers
    my_sessions: ->
        Docs.find
            type: 'session'
            author_id: Meteor.userId()
            parent_id: FlowRouter.getParam('doc_id')
