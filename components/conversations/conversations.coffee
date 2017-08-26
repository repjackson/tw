FlowRouter.route '/conversations', action: (params) ->
    BlazeLayout.render 'layout',
        cloud: 'conversation_cloud'
        main: 'conversations'

FlowRouter.route '/conversation/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'conversation_page'



Meteor.methods
    create_conversation: (tags=[])->
        Docs.insert
            tags: tags
            type: 'conversation'
            author_id: Meteor.userId()
            participant_ids: [Meteor.userId()]
        # FlowRouter.go "/conversation/#{id}"

    close_conversation: (id)->
        Docs.remove id
        Messages.remove conversation_id: id

    join_conversation: (id)->
        Docs.update id,
            $addToSet:
                participant_ids: Meteor.userId()

    leave_conversation: (id)->
        Docs.update id,
            $pull:
                participant_ids: Meteor.userId()




if Meteor.isClient
    Template.conversations.onCreated ->
        @autorun -> Meteor.subscribe('docs', selected_conversation_tags.array(), 'conversation')
    
    Template.conversations.helpers
        conversations: -> 
            Docs.find
                type: 'conversation'
    
    Template.conversations.events
        'click #create_conversation': ->
            Meteor.call 'create_conversation', (err,id)->
                FlowRouter.go "/conversation/#{id}"

    Template.conversation.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
        @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
        @autorun -> Meteor.subscribe 'people_list', FlowRouter.getParam('doc_id')
    
    
    Template.conversation.helpers
        conversation: -> Docs.findOne FlowRouter.getParam('doc_id')
    
        in_conversation: -> if Meteor.userId() in @participant_ids then true else false
    
        conversation_messages: -> 
            Docs.find
                parent_id: @_id
    
        
        participants: ->
            participant_array = []
            for participant in @participant_ids
                participant_object = Meteor.users.findOne participant
                participant_array.push participant_object
            return participant_array
    
    
    Template.conversation.events
        'click .join_conversation': -> Meteor.call 'join_conversation', @_id
        'click .leave_conversation': -> Meteor.call 'leave_conversation', @_id
    
        'keydown .add_message': (e,t)->
            e.preventDefault
            if e.which is 13
                parent_id = FlowRouter.getParam('doc_id')
                console.log parent_id
                body = t.find('.add_message').value.trim()
                if body.length > 0
                    console.log body
                    Meteor.call 'add_doc', body, parent_id, ['conversation', 'message'], (err,res)->
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


if Meteor.isServer
    Meteor.publish 'people_list', (conversation_id) ->
        conversation = Docs.findOne conversation_id
        Meteor.users.find
            _id: $in: conversation.participant_ids



    Meteor.publish 'conversation_messages', (conversation_id) ->
        Messages.find
            conversation_id: conversation_id