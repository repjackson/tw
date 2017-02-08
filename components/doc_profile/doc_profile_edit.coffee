FlowRouter.route '/edit_profile/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'doc_profile_edit'



if Meteor.isClient

    Template.doc_profile_edit.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'doc', FlowRouter.getParam('doc_id')
        
    Template.doc_profile_edit.helpers
        profile: ->
            Docs.findOne FlowRouter.getParam('doc_id')
        
            
            
    Template.doc_profile_edit.events
        'click #save': ->
            FlowRouter.go "/view_profile/#{@_id}"


        'click #delete': ->
            swal {
                title: 'Delete?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                doc = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.remove doc._id, ->
                    FlowRouter.go "/demo"
