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
                sort: timestamp: -1
    
        conversation_tag_class:->
            if @valueOf() in selected_conversation_tags.array() then 'teal' else ''
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
            
            conversation_doc = Docs.findOne _id: group_id
            message_doc = Docs.findOne new_message_id
            message_author = Meteor.users.findOne message_doc.author_id
            
            message_link = "https://www.toriwebster.com/view/#{conversation_doc._id}"
            # console.log 'message author', message_author
            # console.log 'message_doc', message_doc
            
            this.unblock()
            
            offline_ids = []
            for participant_id in conversation_doc.participant_ids
                user = Meteor.users.findOne participant_id
                console.log participant_id
                if user.status.online is true
                    console.log 'user online:', user.profile.first_name
                else
                    offline_ids.push user._id
                    console.log 'user offline:', user.profile.first_name
            
            
            for offline_id in offline_ids
                console.log 'offline id', offline_id
                offline_user = Meteor.users.findOne offline_id
                
                Email.send
                    to: " #{offline_user.profile.first_name} #{offline_user.profile.last_name} <#{offline_user.emails[0].address}>",
                    from: "TWI Admin <no-reply@toriwebster.com>",
                    subject: "New Message from #{message_author.profile.first_name} #{message_author.profile.last_name}",
                    html: 
                        "<h4>#{message_author.profile.first_name} just sent the following message while you were offline: </h4>
                        #{body} <br><br>
                        
                        Click <a href=#{message_link}> here to view.</a><br><br>
                        You can unsubscribe from this conversation in the Actions panel.
                        "
                    
                    # html: 
                    #     "<h4>#{message_author.profile.first_name} just sent the following message: </h4>
                    #     #{body} <br>
                    #     In conversation with tags: #{conversation_doc.tags}. \n
                    #     In conversation with description: #{conversation_doc.description}. \n
                    #     \n
                    #     Click <a href="/view/#{_id}"
                    # "
            return new_message_id
                
