if Meteor.isClient
    
    FlowRouter.route '/checkin/view/:doc_id',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'checkin_view'
    
    
    
    
    Template.checkin_view.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.checkin_view.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

        resonates_with_people: ->
            if @favoriters
                if @favoriters.length > 0
            # console.log @favoriters
                    Meteor.users.find _id: $in: @favoriters
        

    Template.checkin_view.events
