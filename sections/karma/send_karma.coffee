if Meteor.isClient
    FlowRouter.route '/karma/send', action: (params) ->
        BlazeLayout.render 'layout',
            # cloud: 'cloud'
            main: 'send_karma'
    
    Template.send_karma.onCreated -> 
        @autorun -> Meteor.subscribe('karma_transactions')
    
    Template.send_karma.helpers
        karma_transactions: ->
            Transactions.find()
    
    Template.send_karma.events

if Meteor.isServer
    Meteor.publish 'karma_transactions', ->
        Transactions.find
            type: 'karma'