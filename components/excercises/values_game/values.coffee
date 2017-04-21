if Meteor.isClient
    FlowRouter.route '/values', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'values'

    Template.values.onCreated -> 
        @autorun -> Meteor.subscribe('docs', [], 'value_card')
    
    
    Template.values.helpers
        liked_cards: ->
            Docs.find
                type: 'value_card'
                upvoters: $in: [Meteor.userId()]
        
        unvoted_cards: ->
            Docs.find
                type: 'value_card'
                $and: [
                    { upvoters: $nin: [Meteor.userId()] }
                    { downvoters: $nin: [Meteor.userId()] }
                ]
        
        disliked_cards: ->
            Docs.find
                type: 'value_card'
                downvoters: $in: [Meteor.userId()]
    
    
    Template.values.events
        'click #add_value_card': ->
            new_id = Docs.insert
                type: 'value_card'
            Session.set 'editing_id', new_id
                
    Template.value_card.events
