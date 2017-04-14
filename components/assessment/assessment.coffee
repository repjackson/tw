FlowRouter.route '/assessment', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'assessment'

if Meteor.isClient
    Template.assessment.onCreated -> 
        @autorun -> Meteor.subscribe('docs', [], 'assessment_question')
    
    
    Template.assessment.helpers
        all_questions: ->
            Docs.find
                type: 'assessment_question'
        relationship_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['relationship']
        
        physical_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['physical']
        
        business_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['business']
        
        financial_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['financial']
        
        spiritual_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['spiritual']
        
        mental_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['mental']
        
        lifestyle_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['lifestyle']
        
    
    
    Template.assessment.events
        'click #add_assessment_question': ->
            new_id = Docs.insert
                type: 'assessment_question'
            Session.set 'editing_id', new_id
                
