FlowRouter.route '/conversations', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'conversations'

FlowRouter.route '/conversation/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'conversation_page'



Meteor.methods
    create_conversation: (tags=[])->
        Docs.insert
            tags: tags
            type: 'conversation'
            participant_ids: [Meteor.userId()]
        # FlowRouter.go "/conversation/#{id}"

    close_conversation: (conversation_id)->
        Docs.remove conversation_id
        Docs.remove 
            type: 'message'
            group_id: conversation_id

    join_conversation: (conversation_id)->
        Docs.update conversation_id,
            $addToSet:
                participant_ids: Meteor.userId()

    leave_conversation: (conversation_id)->
        Docs.update conversation_id,
            $pull:
                participant_ids: Meteor.userId()




if Meteor.isClient
    Template.conversations.onCreated ->
        @autorun -> Meteor.subscribe('conversations', selected_tags.array(), selected_participant_ids.array())
        @view_published = new ReactiveVar(true)

    Template.conversations.helpers
        conversations: -> 
            if Template.instance().view_published.get() is true
                Docs.find {
                    type: 'conversation'
                    published: true
                }, sort: timestamp: -1
            else
                Docs.find {
                    participant_ids: $in: [Meteor.userId()]
                    type: 'conversation'
                    published: false
                }, sort: timestamp: -1
            
            
        viewing_published: -> Template.instance().view_published.get() is true
        viewing_private: -> Template.instance().view_published.get() is false  
    
    
    
    Template.conversations.events
        'click #create_conversation': ->
            Meteor.call 'create_conversation', (err,id)->
                FlowRouter.go "/conversation/#{id}/edit"

    # 'click #create_conversation': ->
    #     id = Docs.insert 
    #         type: 'conversation'
    #         participant_ids: [Meteor.userId()]
    #     FlowRouter.go "/conversation/#{id}"


        'click #view_private_conversations': (e,t)-> 
            t.view_published.set(false)
            console.log t.view_published.get()
            
        'click #view_published_conversations': (e,t)-> 
            t.view_published.set(true)    

            console.log t.view_published.get()


    Template.conversation.onCreated ->
        # @autorun => Meteor.subscribe 'doc', @data._id
        @autorun => Meteor.subscribe 'group_docs', @data._id
        @autorun => Meteor.subscribe 'people_list', @data._id
    
    
    Template.conversation.helpers
        conversation: -> Docs.findOne @_id
    
        in_conversation: -> if Meteor.userId() in @participant_ids then true else false
    
        conversation_messages: -> 
            Docs.find {
                type: 'message'
                group_id: @_id },
                sort: timestamp: 1
    
        
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


if Meteor.isServer
    Meteor.publish 'people_list', (conversation_id) ->
        # console.log conversation_id
        conversation = Docs.findOne conversation_id
        Meteor.users.find
            _id: $in: conversation.participant_ids



    Meteor.publish 'conversation_messages', (conversation_id) ->
        Docs.find
            type: 'message'
            conversation_id: conversation_id
    
    
    publishComposite 'participant_ids', (selected_tags, selected_participant_ids)->
        
        {
            find: ->
                self = @
                match = {}
                # console.log selected_participant_ids
                # console.log selected_tags
                match.type = 'conversation'
                if selected_tags.length > 0 then match.tags = $all: selected_tags
                if selected_participant_ids.length > 0 then match.participant_ids = $in: selected_participant_ids
                match.published = true
                
                cloud = Docs.aggregate [
                    { $match: match }
                    { $project: participant_ids: 1 }
                    { $unwind: "$participant_ids" }
                    { $group: _id: '$participant_ids', count: $sum: 1 }
                    { $match: _id: $nin: selected_participant_ids }
                    { $sort: count: -1, _id: 1 }
                    { $limit: 20 }
                    { $project: _id: 0, text: '$_id', count: 1 }
                    ]
            
            
                # console.log cloud
                
                # author_objects = []
                # Meteor.users.find _id: $in: cloud.
            
                cloud.forEach (participant_ids) ->
                    self.added 'participant_ids', Random.id(),
                        text: participant_ids.text
                        count: participant_ids.count
                self.ready()
            
            # children: [
            #     { find: (doc) ->
            #         Meteor.users.find 
            #             _id: doc.participant_ids
            #         }
            #     ]    
        }            
        
        
    Meteor.publish 'conversations', (selected_tags, selected_participant_ids, view_published)->
    
        self = @
        match = {}
        # console.log selected_participant_ids
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        if view_published is true
            match.published = true
            if selected_participant_ids.length > 0 then match.participant_ids = $in: selected_participant_ids
        else if view_published = false
            match.published = false
            selected_participant_ids.push Meteor.userId()
            match.participant_ids = $in: selected_participant_ids
        # if view_mode
        #     if view_mode is 'mine'
        #         match
        #         match.participant_ids = $in: [Meteor.userId()]
        # else
            # if selected_participant_ids.length > 0 then match.participant_ids = $in: selected_participant_ids
                
                
        match.type = 'conversation'
        # console.log match
        
        cursor = Docs.find match
        # console.log cursor.count()
        return cursor
        
        
    publishComposite 'conversation', (doc_id)->
        {
            find: ->
                Docs.find doc_id
            children: [
                { find: (conversation)->
                    Meteor.users.find
                        _id: $in: conversation.participant_ids
                }
            ]
        }