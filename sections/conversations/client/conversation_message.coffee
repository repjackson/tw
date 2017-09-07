if Meteor.isClient
    Template.conversation_message.onRendered ->
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 500