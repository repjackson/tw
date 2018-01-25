Template.edit_site.onCreated ->
    @autorun -> Meteor.subscribe('child_docs', FlowRouter.getParam('doc_id'))
Template.edit_site.onRendered ->
    Meteor.setTimeout =>
        $('.menu .item').tab()
    , 1000

Template.edit_site.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    white_button_class: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.nav.color is 'white' then 'blue' else 'basic'
    black_button_class: -> 
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.nav.color is 'black' then 'blue' else 'basic'

    child_nav_toggle_class: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if @_id in doc.nav.child_ids then 'blue' else 'basic'

    slider_toggle_class: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.slider.enabled is true then 'blue' else 'basic'


Template.edit_site.events
    'click #make_nav_bar_black': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "nav.color": 'black'

    'click #make_nav_bar_white': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "nav.color": 'white'


    'click .toggle_child_nav_selection': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.nav.child_ids and @_id in doc.nav.child_ids
            Docs.update doc._id,
                $pull: "nav.child_ids": @_id
        else
            Docs.update doc._id,
                $addToSet: "nav.child_ids": @_id
            
        
    'click #toggle_home_slider': ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "slider.enabled": !doc.slider.enabled

        

Template.view_site.onRendered ->
    Session.set('current_site_id', @data._id)