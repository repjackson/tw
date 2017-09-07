if Meteor.isClient
    Template.conversation_message.onRendered ->
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 500
        
        
    Template.conversation_message.helpers
        message_segment_class: -> if Meteor.userId() in @read_by then 'basic' else ''
        read: -> Meteor.userId() in @read_by

    Template.conversation_message.events
        'click .mark_read': (e,t)-> 
            $(e.currentTarget).closest('.message_segment').transition('pulse')
            Docs.update @_id, $addToSet: read_by: Meteor.userId()
        
        'click .mark_unread': (e,t)-> 
            $(e.currentTarget).closest('.message_segment').transition('pulse')
            Docs.update @_id, $pull: read_by: Meteor.userId()


