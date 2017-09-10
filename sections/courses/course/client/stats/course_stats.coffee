if Meteor.isClient
    FlowRouter.route '/course/sol/stats', 
        name: 'course_stats'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_stats'
    
    
    
    Template.course_stats.onCreated ->
        @autorun => Meteor.subscribe('my_course_stats', selected_tags.array())
        @autorun => Meteor.subscribe('pinned_tags', selected_tags.array())
    
        
    Template.course_stats.onRendered ->
    
    Template.course_stats.helpers
        modules: -> 
            Docs.find
                pinned_ids: $in: [Meteor.userId()]
    
        stats_count: ->
            Docs.find(pinned_ids: $in: [Meteor.userId()]).count()
            
            
    Template.course_stats.events
    
if Meteor.isServer
    Meteor.publish 'my_course_stats', ->
        Docs.find
            tags: $in: 