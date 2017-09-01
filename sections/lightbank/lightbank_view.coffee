if Meteor.isClient
    
    FlowRouter.route '/lightbank/view/:doc_id',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'lightbank_view'
    
    
    
    
    Template.lightbank_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.lightbank_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

        resonates_with_people: ->
            if @favoriters
                if @favoriters.length > 0
            # console.log @favoriters
                    Meteor.users.find _id: $in: @favoriters
        

    Template.lightbank_view.events
