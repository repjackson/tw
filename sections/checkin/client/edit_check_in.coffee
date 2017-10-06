Template.edit_checkin.events
    'click #delete_doc': ->
        if confirm 'Delete this doc?'
            Docs.remove @_id
            FlowRouter.go '/checkin'

# Template.edit_check_in.helpers
#     check_in_suggestions: -> [
         
        
        
        
#         ]
        