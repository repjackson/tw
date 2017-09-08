if Meteor.isClient
    FlowRouter.route '/journal', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'journal'
    
    @selected_author_ids = new ReactiveArray []
    # Session.setDefault 'view_mode', 'all'
    Template.journal.onCreated -> 
        self = @
        @autorun => 
            Meteor.subscribe('journal_docs', 
                selected_tags.array(), 
                selected_author_ids.array()
                view_mode= Session.get('view_mode')
                )

    
    Template.journal_doc_view.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500

    
    Template.journal.helpers
        journal_entries: -> 
            match = {}
            match.type = 'journal'
            if selected_author_ids.array().length > 0 then match.author_id = $in: selected_author_ids.array()
            Docs.find match, 
                sort:
                    timestamp: -1
                limit: 5
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

            
        journal_card_class: -> if @published then 'blue' else ''
        
    
    Template.journal.events
    
        'click #add_journal_entry': ->
            new_id = Docs.insert 
                type:'journal'
            Session.set 'view_unpublished', true
            FlowRouter.go("/journal/#{new_id}/edit")
        

    
    Template.journal_doc_view.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
        journal_card_class: -> if @published then 'blue' else ''

        read: -> Meteor.userId() in @read_by
        liked: -> Meteor.userId() in @liked_by
        
        read_count: -> @read_by.length    
        liked_count: -> @liked_by.length    


    Template.journal_doc_view.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())

        'click .mark_read': (e,t)-> 
            $(e.currentTarget).closest('.journal_segment').transition('pulse')
            Docs.update @_id, $addToSet: read_by: Meteor.userId()
            
        'click .mark_unread': (e,t)-> 
            $(e.currentTarget).closest('.journal_segment').transition('pulse')
            Docs.update @_id, $pull: read_by: Meteor.userId()





if Meteor.isServer
    publishComposite 'journal_docs', (selected_tags, selected_author_ids, view_mode)->
        {
            find: ->
                self = @
                match = {}
                # match.tags = $all: selected_tags
                if selected_tags.length > 0 then match.tags = $all: selected_tags
                # console.log selected_author_ids
                if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
                # match.published = true
                
                match.type = 'journal'
                
                if view_mode is 'mine'
                    match.author_id = Meteor.userId()
                else if view_mode is 'resonates'
                    match.favoriters = $in: [@userId]
                else if view_mode is 'all'
                    match.published = true
                
                Docs.find match,
                    sort: timestamp: -1
            children: [
                {
                    find: (doc)->
                        Meteor.users.find
                            _id: doc.author_id
                }
                {
                    find: (doc)->
                        Docs.find
                            _id: doc.parent_id
                }
            ]
        }



    Meteor.methods
        convert_journal_docs: ->
            count = Docs.find(
                author_id: '2hjhjPYPwxAqxj8BC'
                ).count()
            console.log count
            
            # Docs.update {
            #     author_id: '2hjhjPYPwxAqxj8BC'
            # }, {
            #     $set: 
            #         author_id: 'FKnvuPnXbtBSPbES5'
            #         type: 'journal'
            # }, multi: true
                