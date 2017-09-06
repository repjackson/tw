if Meteor.isClient
    Template.doc_emotion.onCreated ->
        Meteor.setTimeout ->
            $('.progress').progress()
        , 2000
    
    
    
    Template.doc_emotion.helpers
        sadness_percent: -> @sadness*100            
        joy_percent: -> @joy*100            
        disgust_percent: -> @disgust*100            
        anger_percent: -> @anger*100            
        fear_percent: -> @fear*100            
