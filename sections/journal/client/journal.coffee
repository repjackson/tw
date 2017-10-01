FlowRouter.route '/journal', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'journal'

Template.journal.events
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal'
        FlowRouter.go("/edit/#{new_journal_id}")