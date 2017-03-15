@Pages = new Meteor.Collection 'pages'

FlowRouter.route '/about', action: ->
    BlazeLayout.render 'layout', 
        main: 'about'

FlowRouter.route '/privacy', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'privacy'

FlowRouter.route '/contact', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'contact'

FlowRouter.route '/terms-of-use', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'terms-of-use'


FlowRouter.route '/page/edit/:page_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_page'

FlowRouter.route '/page/view/:page_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_page'


if Meteor.isClient
    Template.pages.onCreated ->
        @autorun -> Meteor.subscribe 'pages'

    Template.pages.helpers
        pages: ->
            Pages.find()
            
    Template.pages.events
        'click #add_page': ->
            id = Pages.insert {}
            FlowRouter.go "/page/edit/#{id}"


if Meteor.isServer
    Meteor.publish 'pages', ->
        Pages.find()
    
    
    
    Pages.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
