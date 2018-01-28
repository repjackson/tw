FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        if selected_theme_tags
            selected_theme_tags.clear()
        BlazeLayout.render 'layout',
            nav: 'nav'
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    @autorun => Meteor.subscribe 'new_facet', 
        selected_theme_tags.array(), 
        FlowRouter.getParam('doc_id')
        type = null
        tag_limit = null
        doc_limit = 10
        view_private = Session.get 'view_private'
    
Template.view_doc.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            doc = Docs.findOne FlowRouter.getParam('doc_id')
            Meteor.setTimeout ->
                if doc
                    if doc.title
                        document.title = doc.title
            , 500
    

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    view_type_template: -> "view_#{@type}"
    show_parent_link: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.type is 'site' then false else true
        
        
Template.view_doc.events
    'click #toggle_admin_mode': ->
        if Session.equals('admin_mode', true) then Session.set('admin_mode', false)
        else if Session.equals('admin_mode', false) then Session.set('admin_mode', true)
        Session.set 'editing_id', null
        Session.set 'view_published', null
    
    

        
        
        