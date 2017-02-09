FlowRouter.route '/admin/newsletter', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        sub_nav: 'admin_nav'
        main: 'newsletter_subscriptions'
 
@NewsletterSubscriptions = new Meteor.Collection 'newsletter_subscriptions'


if Meteor.isClient
    Template.newsletter_subscriptions.onCreated ->
        @autorun -> Meteor.subscribe 'newsletter_subscriptions'
        
    Template.newsletter_subscriptions.helpers
        subscriptions: ->
            NewsletterSubscriptions.find()
            
            
if Meteor.isServer
    Meteor.publish 'newsletter_subscriptions', ->
        NewsletterSubscriptions.find()