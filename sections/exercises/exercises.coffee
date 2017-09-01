if Meteor.isClient
    FlowRouter.route '/exercises', action: ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            # sub_sub_nav: 'inspire_u_nav'
            main: 'exercises'
    
    
    Template.exercises.onCreated -> 
        @autorun -> Meteor.subscribe('exercises')
    Template.exercises.helpers
        exercises: -> Docs.find { type: 'exercise'}
    
    Template.exercise_card.onCreated -> 
        @autorun => Meteor.subscribe('exercise_sessions', @data.slug)
    Template.exercise_card.helpers
        completed: -> Docs.findOne { type: 'exercise_session', exercise_slug: @slug}
    
    Template.exercises.events
        'click #add_exercise': ->
            id = Docs.insert type: 'exercise'
            FlowRouter.go "/edit/#{id}"
    
    
if Meteor.isServer
    Meteor.publish 'exercises', (view_mode)->
        
        me = Meteor.users.findOne @userId
        self = @
        match = {}
        if view_mode is 'mine'
            # if not me.courses
            #     Meteor.users.update @userId,
            #         $set: courses: []
            # else
            match._id = $in: me.exercises
        if not @userId or not Roles.userIsInRole(@userId, ['admin'])
            match.published = true
                
        match.type = 'exercise'        
                
        Docs.find match
    
    
    Meteor.publish 'exercise_questions', (selected_exercise_question_tags=[], exercise_slug)->
        
        match = {}
        if selected_exercise_question_tags.length > 0 then match.tags = $all: selected_exercise_question_tags
        match.type = 'exercise_question'
        match.exercise_slug = exercise_slug
        
        Docs.find match
