FlowRouter.route '/journal', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'journal'

Template.journal.events
    'click #add_journal_entry': ->
        new_journal_id = Docs.insert
            type: 'journal'
        FlowRouter.go("/view/#{new_journal_id}")
        Session.set 'editing', true