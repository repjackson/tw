FlowRouter.route '/file/:file_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_file'

Template.edit_file.onCreated ->
    @autorun -> Meteor.subscribe 'file', @_id


Template.edit_file.helpers
    file: -> Files.findOne @_id
    
        
Template.edit_file.events
    'click #save_file': ->
        Session.set 'editing_id', null
        
    'blur #title': (e,t)->
        # alert 'hi'
        title = $(e.currentTarget).closest('#title').val()
        Files.update @_id,
            $set: title: title
            
    'blur #link': (e,t)->
        # alert 'hi'
        link = $(e.currentTarget).closest('#link').val()
        Files.update @_id,
            $set: link: link
            
    'blur #description': (e,t)->
        # alert 'hi'
        description = $(e.currentTarget).closest('#description').val()
        Files.update @_id,
            $set: description: description
            
    'click #delete_file': ->
        self = @
        swal {
            title: "Delete '#{self.title}' file?"
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            Files.remove self._id
