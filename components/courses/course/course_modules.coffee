if Meteor.isClient
    FlowRouter.route '/course/:course_slug/modules', 
        name: 'course_modules'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_modules'
    
    Template.course_modules.onCreated ->
        # @autorun -> Meteor.subscribe 'course_modules', FlowRouter.getParam('course_slug')
        @autorun -> Meteor.subscribe 'sol_modules'
    
    
    
    Template.course_modules.helpers
        # modules: -> Modules.find { }, sort: number: 1
        
        sol_modules: ->
            Docs.find {
                tags: $all: ['sol','module'] },
                sort: number: 1
                
            
        module_is_available: ->
            # if 'sol_demo' in Meteor.user().courses  or 'sol_demo' in Meteor.user().roles and @number < 2
            #     return true
            if 'sol' in Meteor.user()?.courses and @number < 2
                return true
            else if 'admin' in Meteor.user().roles 
                return true
            else 
                return false
    
    
    Template.course_modules.events
        'click #add_sol_module': ->
            Docs.insert
                tags: ['sol','module']
            
            
if Meteor.isServer
    Meteor.publish 'sol_modules', ->
        Docs.find
            tags: $all: ['sol','module']
