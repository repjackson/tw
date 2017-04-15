FlowRouter.route '/assessment', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'assessment'

if Meteor.isClient
    Template.assessment.onCreated -> 
        @autorun -> Meteor.subscribe('docs', [], 'assessment_question')
    
    
    Template.assessment.helpers
        unpublished_questions: ->
            Docs.find
                type: 'assessment_question'
                # published: false
                
        relationship_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['relationship']
                published: true
        
        physical_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['physical']
                published: true
        
        business_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['business']
                published: true
        
        financial_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['financial']
                published: true
        
        spiritual_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['spiritual']
                published: true
        
        mental_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['mental']
                published: true
        
        lifestyle_questions: ->
            Docs.find
                type: 'assessment_question'
                tags: $in: ['lifestyle']
                published: true
        
    
    
    Template.assessment.events
        'click #add_assessment_question': ->
            new_id = Docs.insert
                type: 'assessment_question'
            Session.set 'editing_id', new_id
                
