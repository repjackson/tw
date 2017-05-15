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
            if Roles.userIsInRole(Meteor.userId(), 'sol_demo') and @number < 2
                return true
            else if Roles.userIsInRole(Meteor.userId(), ['sol', 'admin']) 
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
