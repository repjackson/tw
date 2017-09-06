if Meteor.isClient
    
    FlowRouter.route '/journal/view/:doc_id',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'journal_view'
    
    
    
    
    Template.journal_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

    Template.journal_view.onCreated ->
        Meteor.setTimeout ->
            $('.progress').progress()
        , 2000

    Template.journal_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')


    Template.journal_view.events
