if Meteor.isClient
    FlowRouter.route '/transaction/:doc_id/view',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'transaction_view'
    
    
    
    
    Template.transaction_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'transaction', FlowRouter.getParam('doc_id')


    Template.transaction_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')
        balance_after_transaction: ->Meteor.user().points - @point_price

        can_mark_complete: -> 
            not @reviewed and Meteor.userId() is @recipient_id or Roles.userIsInRole(Meteor.userId(), 'admin')
        can_review: -> @completed and Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
    
        vote_up_button_class: ->
            if not Meteor.userId() then 'disabled'
            else if @upvoters and Meteor.userId() in @upvoters then 'green'
            else 'outline'
    
        vote_down_button_class: ->
            if not Meteor.userId() then 'disabled'
            else if @downvoters and Meteor.userId() in @downvoters then 'red'
            else 'outline'

    Template.transaction_view.events
        'click #mark_complete': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: completed: true
        'click #unmark_complete': ->
            Docs.update FlowRouter.getParam('doc_id'),
                $set: completed: false

        'click .vote_up': (e,t)-> 
            # console.log @
            Meteor.call 'transaction_vote_up', @_id
            # $(e.currentTarget).closest('.vote_up').transition('pulse')
    
        'click .vote_down': (e,t)-> 
            Meteor.call 'transaction_vote_down', @_id
            # $(e.currentTarget).closest('.vote_down').transition('pulse')


if Meteor.isServer
    publishComposite 'transaction', (doc_id)->
        {
            find: -> Docs.find doc_id
            children: [
                {
                    find: (doc)->
                        Meteor.users.find
                            _id: doc.recipient_id
                    }
                {
                    find: (doc)->
                        Meteor.users.find
                            _id: doc.author_id
                    }
                {
                    find: (doc)->
                        Docs.find
                            _id: doc.parent_id
                    }
                ]
            }
            
Meteor.methods        
    transaction_vote_up: (transaction_id)->
        transaction = Docs.findOne transaction_id
        service = Docs.findOne transaction.parent_id
        if not transaction.upvoters
            Docs.update transaction_id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in transaction.upvoters #undo upvote
            Docs.update transaction_id,
                $pull: upvoters: Meteor.userId()
                $set: reviewed: false
                $inc: points: -1
            Docs.update service._id,
                $inc: points: -1
            Meteor.users.update service.author_id, $inc: points: -1

        else if Meteor.userId() in transaction.downvoters #switch downvote to upvote
            Docs.update transaction_id,
                $pull: downvoters: Meteor.userId()
                $set: reviewed: true
                $addToSet: upvoters: Meteor.userId()
                $inc: points: 2
            Docs.update service._id,
                $inc: points: 2
            Meteor.users.update service.author_id, $inc: points: 2

        else #clean upvote
            Docs.update transaction_id,
                $addToSet: upvoters: Meteor.userId()
                $set: reviewed: true
                $inc: points: 1
            Docs.update service._id,
                $inc: points: 1
            Meteor.users.update service.author_id, $inc: points: 1
            # Meteor.users.update Meteor.userId(), $inc: points: -1

    transaction_vote_down: (transaction_id)->
        transaction = Docs.findOne transaction_id
        service = Docs.findOne transaction.parent_id

        if not transaction.downvoters
            Docs.update transaction_id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in transaction.downvoters #undo downvote
            Docs.update transaction_id,
                $pull: downvoters: Meteor.userId()
                $set: reviewed: false
            Docs.update service._id,
                $inc: points: 1
            Meteor.users.update service.author_id, $inc: points: 1

        else if Meteor.userId() in transaction.upvoters #switch upvote to downvote
            Docs.update transaction_id,
                $pull: upvoters: Meteor.userId()
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -2
            Docs.update service._id,
                $inc: points: -2
            Meteor.users.update service.author_id, $inc: points: -2

        else #clean downvote
            Docs.update transaction_id,
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -1
                $set: reviewed: true
            Docs.update service._id,
                $inc: points: -1
            Meteor.users.update service.author_id, $inc: points: -2
            # Meteor.users.update Meteor.userId(), $inc: points: -1
        
            