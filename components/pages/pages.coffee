@Pages = new Meteor.Collection 'pages'

FlowRouter.route '/about', action: ->
    BlazeLayout.render 'layout', 
        main: 'about'

FlowRouter.route '/faq', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'faq'

FlowRouter.route '/contact', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'contact'

FlowRouter.route '/volunteer', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'volunteer'


FlowRouter.route '/page/edit/:page_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_page'

FlowRouter.route '/page/view/:page_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_page'


if Meteor.isServer
    Pages.allow
        insert: (userId, doc) -> doc.author_id is userId
        update: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> doc.author_id is userId or Roles.userIsInRole(userId, 'admin')
    
