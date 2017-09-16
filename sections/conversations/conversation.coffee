if Meteor.isClient
    Template.conversation_messages_pane.onCreated ->
        # @autorun => Meteor.subscribe 'doc', @data._id
        @autorun => Meteor.subscribe 'group_docs', @data._id
        @autorun => Meteor.subscribe 'people_list', @data._id
    
    Template.conversation_messages_pane.helpers
        conversation_messages: -> 
            Docs.find {
                type: 'message'
                group_id: @_id },
                sort: timestamp: 1
    
    Template.conversation_messages_pane.helpers
        conversation_tag_class:->
            if @valueOf() in selected_conversation_tags.array() then 'teal' else ''
    Template.conversation_messages_pane.helpers
        conversation: -> Docs.findOne @_id
    
        in_conversation: -> if Meteor.userId() in @participant_ids then true else false
    
        
        participants: ->
            participant_array = []
            for participant in @participant_ids
                participant_object = Meteor.users.findOne participant
                participant_array.push participant_object
            return participant_array
    
    
    Template.conversation_messages_pane.events
        'click .join_conversation': (e,t)-> Meteor.call 'join_conversation', @_id, ->
        'click .leave_conversation': (e,t)-> Meteor.call 'leave_conversation', @_id, ->

    
        'keydown .add_message': (e,t)->
            e.preventDefault
            if e.which is 13
                group_id = @_id
                # console.log group_id
                body = t.find('.add_message').value.trim()
                if body.length > 0
                    # console.log body
                    Meteor.call 'add_message', body, group_id, (err,res)=>
                        if err then console.error err
                        else
                            console.log res
                            t.find('.add_message').value = ''
    
        'click .close_conversation': ->
            self = @
            swal {
                title: "Close Conversation?"
                text: 'This will also delete the messages'
                type: 'warning'
                showCancelButton: true
                animation: false
                confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Close'
                closeOnConfirm: true
            }, ->
                Meteor.call 'close_conversation', self._id, ->
                    FlowRouter.go '/conversations'
                # console.log self
                # swal "Submission Removed", "",'success'
                return
        
    Template.edit_conversation.events
        'click #delete_doc': ->
            if confirm 'Delete this Conversation?'
                Docs.remove @_id
                FlowRouter.go '/conversation'

if Meteor.isServer
    Meteor.methods
        add_message: (body,group_id)->
            new_message_id = Docs.insert
                body: body
                type: 'message'
                group_id: group_id
                tags: ['conversation', 'message']
            
            conversation_doc = Docs.findOne
                _id: group_id
            console.log 'new message id', new_message_id
            console.log 'conversation people', conversation_doc.participant_ids
            Email.send
                to: "repjackson@gmail.com",
                from: "from.address@email.com",
                subject: "Example Email",
                text: "The contents of our email in plain text.",
            return new_message_id
                
