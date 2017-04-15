Template.voting.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'


Template.voting.events
    'click .vote_up': -> 
        if Meteor.userId() then Meteor.call 'vote_up', @_id
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() then Meteor.call 'vote_down', @_id
        else FlowRouter.go '/sign-in'




Template.published.events
    'click #publish': ->
        Docs.update @_id,
            $set: published: true

    'click #unpublish': ->
        Docs.update @_id,
            $set: published: false


Template.edit_this_button.events
    'click .edit_this': ->
        Session.set 'editing_id', @_id
    'click .save_doc': ->
        Session.set 'editing_id', null


Template.rating.onRendered ->
   Meteor.setTimeout ->
        $('.ui.rating').rating
            initialRating: 3,
            maxRating: 5
    , 2000



Template.delete.events
    'click #delete': ->
        self = @
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
            Docs.remove self._id
