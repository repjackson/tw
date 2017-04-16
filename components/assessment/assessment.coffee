FlowRouter.route '/assessment', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'assessment'

if Meteor.isClient
    Template.assessment.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), 'assessment_question')
    
    
    Template.assessment.helpers
        unpublished_questions: ->
            Docs.find
                type: 'assessment_question'
                published: false
                
        published_questions: ->
            Docs.find
                type: 'assessment_question'
                published: true
        
        
    
    
    Template.assessment.events
        'click #add_assessment_question': ->
            new_id = Docs.insert
                type: 'assessment_question'
            Session.set 'editing_id', new_id
                
