if Meteor.isClient
    FlowRouter.route '/values', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'values'

    Template.values.onCreated -> 
        @autorun -> Meteor.subscribe('docs', [], 'value_card')
    
    
    Template.values.helpers
        available_cards: ->
            Docs.find
                type: 'value_card'
                # $or: [
                #     { upvoters: $nin: [Meteor.userId()] }
                #     { downvoters: $nin: [Meteor.userId()] }
                # ]
        
        discarded_cards: ->
            Docs.find
                type: 'value_card'
                downvoters: $in: [Meteor.userId()]
    
    
    Template.values.events
        'click #add_value_card': ->
            new_id = Docs.insert
                type: 'value_card'
                
    Template.value_card.events
        'click .edit_card': ->
            Session.set 'editing_id', @_id