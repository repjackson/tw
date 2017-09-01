if Meteor.isClient
    
    FlowRouter.route '/service/view/:doc_id',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'service_view'
    
    
    
    
    Template.service_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.service_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

        resonates_with_people: ->
            if @favoriters
                if @favoriters.length > 0
            # console.log @favoriters
                    Meteor.users.find _id: $in: @favoriters
        

    Template.service_view.events
