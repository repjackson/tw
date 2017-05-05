FlowRouter.route '/file/:file_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_file'

Template.edit_file.onCreated ->
    @autorun -> Meteor.subscribe 'file', @_id


Template.edit_file.helpers
    file: -> Docs.findOne @_id
    
        
Template.edit_file.events
    'click #save_file': ->
        Session.set 'editing_id', null