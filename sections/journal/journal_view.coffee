if Meteor.isClient
    # FlowRouter.route '/journal/:doc_id/view',
    #     action: (params) ->
    #         BlazeLayout.render 'layout',
    #             # top: 'nav'
    #             main: 'view_journal'
    
    
    # Template.view_journal.onCreated ->
    #     @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

    Template.view_journal.onCreated ->
        Meteor.setTimeout ->
            $('.progress').progress()
        , 2000

    # Template.view_journal.helpers
    #     doc: -> Docs.findOne FlowRouter.getParam('doc_id')


    Template.view_journal.events
