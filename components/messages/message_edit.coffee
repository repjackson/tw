if Meteor.isClient
    FlowRouter.route '/message/edit/:message_id', 
        name: 'message_edit'
        action: (params) ->
            BlazeLayout.render 'messages_layout',
                message_content: 'message_edit'

    Template.message_edit.onCreated ->
        @autorun -> Meteor.subscribe('usernames')
        @autorun -> Meteor.subscribe('message', FlowRouter.getParam('message_id'))
        
        
    Template.message_edit.helpers
        message: -> Messages.findOne FlowRouter.getParam('message_id')
        
        getFEContext: ->
            @current_doc = Messages.findOne @_id
            self = @
            {
                _value: self.current_doc.content
                _keepMarkers: true
                _className: 'froala-reactive-meteorized-override'
                toolbarInline: false
                initOnClick: false
                # imageInsertButtons: ['imageBack', '|', 'imageByURL']
                tabSpaces: false
                height: 300
            }

        is_draft: -> @status is 'draft'
        is_sent: -> @status is 'sent'

        status_label_class: ->
            switch @status
                when 'draft' then 'basic'
                when 'sent' then 'green'
        
        message_edit_settings: -> {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Meteor.users
                    field: 'username'
                    matchAll: true
                    template: Template.user_pill
                }
                ]
        }
    

    Template.message_edit.events
        'blur .froala-container': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            message_id = @_id
    
            Messages.update message_id,
                $set: content: html
                    

    
        "autocompleteselect input": (event, template, doc) ->
            # console.log("selected ", doc)
            Messages.update FlowRouter.getParam('message_id'),
                $set: recipient_id: doc._id
                
        'click #remove_recipient': ->
            Messages.update FlowRouter.getParam('message_id'),
                $unset: recipient_id: 1
            
    
        'click #send_message': ->
            message = Messages.findOne FlowRouter.getParam('message_id')
            Messages.update message._id,
                $set: status: 'sent'
            swal "Message Sent", "",'success'
            Meteor.call 'notify', message.recipient_id, 'message sent test', (err, res)->
                if err then console.error err
                else console.log res

        'click #delete_message': ->
            self = @
            swal {
                title: 'Delete Message?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                Messages.remove self._id
                FlowRouter.go '/messages'
if Meteor.isServer
    Meteor.publish 'usernames', ->
        Meteor.users.find {}