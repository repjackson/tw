if Meteor.isClient
    FlowRouter.route '/quizzes', action: ->
        BlazeLayout.render 'layout',
            main: 'quizzes'
    
    
    Template.quizzes.onCreated -> 
        @autorun -> Meteor.subscribe('quizzes')
    Template.quizzes.helpers
        quizzes: -> Docs.find { type: 'quiz'}
    
    Template.quiz_card.onCreated -> 
        @autorun => Meteor.subscribe('quiz_sessions', @data.slug)
    Template.quiz_card.helpers
        completed: -> Docs.findOne { type: 'quiz_session', quiz_slug: @slug}
    
    Template.quizzes.events
        'click #add_quiz': ->
            id = Docs.insert type: 'quiz'
            Session.set 'editing', true

            FlowRouter.go "/view/#{id}"
    
    
if Meteor.isServer
    Meteor.publish 'quizzes', (view_mode)->
        
        me = Meteor.users.findOne @userId
        self = @
        match = {}
        if view_mode is 'mine'
            # if not me.courses
            #     Meteor.users.update @userId,
            #         $set: courses: []
            # else
            match._id = $in: me.quizzes
        if not @userId or not Roles.userIsInRole(@userId, ['admin'])
            match.published = true
                
        match.type = 'quiz'        
                
        Docs.find match
    
    
    Meteor.publish 'quiz_questions', (selected_quiz_question_tags=[], quiz_slug)->
        
        match = {}
        if selected_quiz_question_tags.length > 0 then match.tags = $all: selected_quiz_question_tags
        match.type = 'quiz_question'
        match.quiz_slug = quiz_slug
        
        Docs.find match
