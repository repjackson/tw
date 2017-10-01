Template.edit_journal.events
    'click #delete_doc': ->
        if confirm 'Delete this journal entry?'
            Docs.remove @_id
            FlowRouter.go '/journal'
