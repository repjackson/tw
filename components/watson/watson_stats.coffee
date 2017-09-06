if Meteor.isClient

    Template.analyzed_watson_keywords.helpers
        sadness_percent: -> @sadness*100            
        joy_percent: -> @joy*100            
        disgust_percent: -> @disgust*100            
        anger_percent: -> @anger*100            
        fear_percent: -> @fear*100            
    
    Template.analyzed_watson_keywords.onRendered ->
        Meteor.setTimeout ->
            $('.progress').progress()
            $('.accordion').accordion()
        , 2000
        
    
    Template.call_watson.events
        'click #call_watson': ->
            parameters = 
                'text': @content
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
