if Meteor.isClient
    Template.conversation_message.onRendered ->
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 500
        
        
    Template.conversation_message.helpers
        message_segment_class: -> if Meteor.userId() in @read_by then 'basic' else ''
        read: -> Meteor.userId() in @read_by

        readers: ->
            readers = []
            for reader_id in @read_by
                readers.push Meteor.users.findOne reader_id
            readers


    Template.conversation_message.events
        'click .mark_read, click .text': (e,t)->
            unless Meteor.userId() in @read_by
                Meteor.call 'mark_read', @_id, ->
                    $(e.currentTarget).closest('.message_segment').transition('pulse')
        
        'click .mark_unread': (e,t)-> 
            Meteor.call 'mark_unread', @_id, ->
                $(e.currentTarget).closest('.message_segment').transition('pulse')


Meteor.methods 
    mark_read: (doc_id)-> Docs.update doc_id, $addToSet: read_by: Meteor.userId()
    mark_unread: (doc_id)-> Docs.update doc_id, $pull: read_by: Meteor.userId()