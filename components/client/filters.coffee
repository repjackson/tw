Template.doc_limit.events
    'click #make_1': (e,t)-> Session.set 'doc_limit', 1
    'click #make_5': (e,t)-> Session.set 'doc_limit', 5
    'click #make_10': (e,t)-> Session.set 'doc_limit', 10
    'click #make_20': (e,t)-> Session.set 'doc_limit', 20
    
Template.doc_limit.helpers
    limit_1_class: -> if Session.equals('doc_limit', 1) then 'blue' else 'basic'
    limit_5_class: -> if Session.equals('doc_limit', 5) then 'blue' else 'basic'
    limit_10_class: -> if Session.equals('doc_limit', 10) then 'blue' else 'basic'
    limit_20_class: -> if Session.equals('doc_limit', 20) then 'blue' else 'basic'
    
    

Template.read_filter.events
    'click #view_read': (e,t)-> 
        if Session.equals('view_read', true) then Session.set('view_read', null) else Session.set('view_read', true)
    'click #view_unread': (e,t)-> 
        if Session.equals('view_read', false) then Session.set('view_read', null) else Session.set('view_read', false)
    
Template.read_filter.helpers
    view_read_class: -> if Session.equals('view_read', true) then 'blue' else 'basic'
    view_all_class: -> if Session.equals('view_read', null) then 'blue' else 'basic'
    view_unread_class: -> if Session.equals('view_read', false) then 'blue' else 'basic'    
    
    
    
    
    
Template.published_filter.events
    'click #view_published': (e,t)-> 
        if Session.equals('view_published', true) then Session.set('view_published', null) else Session.set('view_published', true)
    'click #view_private': (e,t)-> 
        if Session.equals('view_published', false) then Session.set('view_published', null) else Session.set('view_published', false)
            
Template.published_filter.helpers
    view_published_class: -> if Session.equals('view_published', true) then 'blue' else 'basic'
    view_private_class: -> if Session.equals('view_published', false) then 'blue' else 'basic'
    
    
    
Template.complete_filter.events
    'click #view_complete': (e,t)-> 
        if Session.equals('view_complete', true) then Session.set('view_complete', null) else Session.set('view_complete', true)
    'click #view_incomplete': (e,t)-> 
        if Session.equals('view_complete', false) then Session.set('view_complete', null) else Session.set('view_complete', false)
    
Template.complete_filter.helpers
    view_complete_class: -> if Session.equals('view_complete', true) then 'blue' else 'basic'
    view_incomplete_class: -> if Session.equals('view_complete', false) then 'blue' else 'basic'    



Template.bookmark_filter.events
    'click #view_bookmarked': (e,t)-> 
        if Session.equals('view_bookmarked', true) then Session.set('view_bookmarked', null) else Session.set('view_bookmarked', true)
    'click #view_unbookmarked': (e,t)-> 
        if Session.equals('view_bookmarked', false) then Session.set('view_bookmarked', null) else Session.set('view_bookmarked', false)
    
Template.bookmark_filter.helpers
    view_bookmarked_class: -> if Session.equals('view_bookmarked', true) then 'blue' else 'basic'
    view_unbookmarked_class: -> if Session.equals('view_bookmarked', false) then 'blue' else 'basic'    
    