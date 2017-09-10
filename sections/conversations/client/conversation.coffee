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
        conversation: -> Docs.findOne @_id
    
        in_conversation: -> if Meteor.userId() in @participant_ids then true else false
    
        
        participants: ->
            participant_array = []
            for participant in @participant_ids
                participant_object = Meteor.users.findOne participant
                participant_array.push participant_object
            return participant_array
    
    
    Template.conversation_messages_pane.events
        'click .join_conversation': -> Meteor.call 'join_conversation', @_id
        'click .leave_conversation': -> Meteor.call 'leave_conversation', @_id
    
        'keydown .add_message': (e,t)->
            e.preventDefault
            if e.which is 13
                group_id = @_id
                # console.log group_id
                body = t.find('.add_message').value.trim()
                if body.length > 0
                    # console.log body
                    Docs.insert
                        body: body
                        type: 'message'
                        group_id: group_id
                        tags: ['conversation', 'message']
                        
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
