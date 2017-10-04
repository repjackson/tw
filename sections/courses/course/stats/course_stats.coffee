if Meteor.isClient
    FlowRouter.route '/course/sol/stats', 
        name: 'course_stats'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_stats'
    
    
    
    Template.course_stats.onCreated ->
        @autorun => Meteor.subscribe('sol_modules')
    
    # Template.module_stats.onCreated ->
    #     @autorun => Meteor.subscribe('doc', @data._id)
    
        
    Template.course_stats.onRendered ->
    
    Template.course_stats.helpers
        modules: -> 
            Docs.find {
                type: 'module'
            }, sort: number: 1
                # number: 
                # author_id: Meteor.userId()

    Template.module_stats.helpers
        module_progress_doc: ->
            # console.log @
            progress_doc = Docs.findOne
                type: 'module_progress'
                parent_id: @_id
                author_id: Meteor.userId()
            # console.log progress_doc
            progress_doc
        
        # stats_count: ->
        #     Docs.find(pinned_ids: $in: [Meteor.userId()]).count()
            
    Template.course_stats.events
            
            
    # Template.module_stats.helpers
    #     module: ->
    #         module = Docs.findOne _id: @parent_id
    #         console.log module
    #         module
            
            
    
if Meteor.isServer
    Meteor.publish 'my_course_stats', ->
        Docs.find
            type: 'module_progress'
            author_id: Meteor.userId()
