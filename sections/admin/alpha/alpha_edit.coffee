if Meteor.isClient
    FlowRouter.route '/alpha_edit/:doc_id', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'alpha_edit'
    
    Template.alpha_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    Template.alpha_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')
        # edit_type_template: -> "edit_#{@type}"
    
    Template.alpha_edit.events
