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

    Template.analyzed_watson_keywords.helpers
        sadness_percent: -> @sadness*100            
        joy_percent: -> @joy*100            
        disgust_percent: -> @disgust*100            
        anger_percent: -> @anger*100            
        fear_percent: -> @fear*100            
    
    Template.analyzed_watson_keywords.onRendered ->
        Meteor.setTimeout ->
            $('.progress').progress()
        , 2000
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 2000
        
    
    Template.call_watson.events
        'click #call_watson': ->
            parameters = 
                'html': @content
                'features':
                    # 'entities':
                    #     'emotion': true
                    #     'sentiment': true
                    #     # 'limit': 2
                    'keywords':
                        'emotion': true
                        'sentiment': true
                        # 'limit': 2
                    # 'concepts': {}
                    # 'categories': {}
                    'emotion': {}
                    # 'metadata': {}
                    # 'relations': {}
                    # 'semantic_roles': {}
                    'sentiment': {}
            Meteor.call 'call_watson', parameters, @_id


    Template.doc_sentiment.onRendered ->
        Meteor.setTimeout ->
            $('.progress').progress()
        , 2000
    
    
    Template.doc_sentiment.helpers
        sentiment_score_percent: -> 
            if @doc_sentiment_score > 0
                @doc_sentiment_score*100
            else
                @doc_sentiment_score*-100
                
            
        sentiment_bar_class: -> if @doc_sentiment_label is 'positive' then 'green' else 'red'
            
        is_positive: -> if @doc_sentiment_label is 'positive' then true else false    