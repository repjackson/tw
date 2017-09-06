if Meteor.isClient
    Template.watson_stats.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        # @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

    Template.watson_stats.onRendered ->
        Meteor.setTimeout ->
            $('.progress').progress()
        , 2000

    Template.watson_stats.helpers
        sadness_percent: -> @sadness*100            
        joy_percent: -> @joy*100            
        disgust_percent: -> @disgust*100            
        anger_percent: -> @anger*100            
        fear_percent: -> @fear*100            
    
    Template.watson_stats.events
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
