if Meteor.isClient
    Template.course_pricing.onCreated ->
        @autorun -> Meteor.subscribe 'usernames'
        @autorun -> Meteor.subscribe 'plans'
    
    # Template.view_plans.onRendered ->
    #     Meteor.setTimeout =>
    #         $('.menu .item').tab()
    #     , 1000
    
    # Template.edit_plans.onRendered ->
    #     Meteor.setTimeout =>
    #         $('.menu .item').tab()
    #     , 1000
    
    Template.view_plans.helpers
        plans: -> Docs.find {type: 'plan'}
    
    
                
    Template.course_pricing.events
        'click #add_plan': ->
            id = Docs.insert
                type: 'plan'
                parent_id: @_id
            FlowRouter.go "/edit/#{id}"
            
            
            
    
    Template.edit_plan.events
        'click #delete_plan': ->
            swal {
                title: 'Delete check in?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                plans = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.remove plans._id, ->
                    FlowRouter.go "/planss"        
                    
                    
            
if Meteor.isServer
    Meteor.publish 'plans', ->
        Docs.find 
            type: 'plan'
            
