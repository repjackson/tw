Template.doc_limit.events
    'click #make_5': (e,t)-> Session.set 'doc_limit', 5
    'click #make_10': (e,t)-> Session.set 'doc_limit', 10
    'click #make_20': (e,t)-> Session.set 'doc_limit', 20
    
Template.doc_limit.helpers
    limit_5_class: -> if Session.equals('doc_limit', 5) then 'blue' else 'basic'
    limit_10_class: -> if Session.equals('doc_limit', 10) then 'blue' else 'basic'
    limit_20_class: -> if Session.equals('doc_limit', 20) then 'blue' else 'basic'