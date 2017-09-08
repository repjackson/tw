if Meteor.isClient
    Template.resonate_button.helpers
        resonate_button_class: -> 
            if Meteor.userId()
                if @favoriters and Meteor.userId() in @favoriters then 'teal' else 'basic'
            else 'grey disabled'
    
    Template.resonate_button.events
        'click .resonate_button': (e,t)-> 
            if Meteor.userId() 
                Meteor.call 'favorite', Template.parentData(0)
                $(e.currentTarget).closest('.resonate_button').transition('pulse')
            else FlowRouter.go '/sign-in'

    
    Template.resonates_list.helpers
        resonates_with_people: ->
            if @favoriters
                if @favoriters.length > 0
            # console.log @favoriters
                    Meteor.users.find _id: $in: @favoriters
        
    Template.doc_matches.onCreated ->
        @is_calculating = new ReactiveVar 'false'
        
        
    Template.doc_matches.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500
        
        
        
    Template.doc_matches.helpers
        # calculate_button_class: ->
            # if Template.instance().is_calculating then 'loading' else ''
        
    Template.doc_matches.events
        'click #compute_doc_matches': ->
            $( "#compute_doc_matches" ).toggleClass( "loading" )
            # console.log @
            Meteor.call 'find_top_doc_matches', @_id, (err, res)->
                $( "#compute_doc_matches" ).toggleClass( "loading" )
                $( ".title" ).addClass( "active" )
                $( ".match_content" ).addClass( "active" )
                # console.log res
                
                
    Template.request_tori_feedback.helpers
        feedback_requested: ->
            
            
    Template.request_tori_feedback.events
        'click #request_feedback': ->
            console.log @
            
    Template.parent_doc_segment.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500
        
        
    Template.view_mode_button.helpers
        viewing_mine: -> Session.equals 'view_mode','mine'  
        viewing_all: -> Session.equals 'view_mode','all'  


    Template.view_mode_button.events
        'click #view_my_entries': (e,t)-> Session.set('view_mode','mine')    
        'click #view_all_entries': (e,t)-> Session.set('view_mode', 'all')    
