if Meteor.isClient

    Template.feature_cards.onCreated ->
        @autorun -> Meteor.subscribe('features', selected_feature_tags.array())
    
    
    Template.feature_cards.helpers
        features: -> 
            Docs.find
                type: 'feature'
            

        tag_class: -> if @valueOf() in selected_feature_tags.array() then 'primary' else ''
    
    
if Meteor.isServer
    Meteor.publish 'features', (selected_feature_tags)->
        match = {}
        if selected_feature_tags.length > 0 then match.tags = $all: selected_feature_tags
        match.type = 'feature'
        
        Docs.find match
