if Meteor.isClient
    FlowRouter.route '/journal/templates', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'journal_templates'
    
    # @selected_author_ids = new ReactiveArray []

    Template.journal_templates.onCreated -> 
        self = @
        @autorun => 
            Meteor.subscribe('journal_templates', 
                selected_theme_tags.array(), 
                selected_author_ids.array()
                Session.get('view_private')
                Session.get('view_unread')
                )
        @autorun -> Meteor.subscribe 'unread_journal_count'
            
                
                
                
                
    Template.view_journal.onCreated ->
        Meteor.setTimeout ->
            $('.progress').progress()
        , 2000

    
    Template.journal_template.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500

    
    Template.journal_templates.helpers
        journal_entries: -> 
            match = {}
            match.type = 'journal'
            if selected_author_ids.array().length > 0 then match.author_id = $in: selected_author_ids.array()
            Docs.find match, 
                sort:
                    timestamp: -1
                limit: 5
    
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'

            
        journal_card_class: -> if @published then 'blue' else ''
        
        published_count: -> Counts.get('unread_journal_count')


    
    Template.journal_template.helpers
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        journal_card_class: -> if @published then 'blue' else ''

        read: -> Meteor.userId() in @read_by
        liked: -> Meteor.userId() in @liked_by
        
        read_count: -> @read_by.length    
        liked_count: -> @liked_by.length    


    Template.journal_template.events
        'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())

        'click .mark_read': (e,t)-> 
            $(e.currentTarget).closest('.journal_segment').transition('pulse')
            Docs.update @_id, $addToSet: read_by: Meteor.userId()
            
        'click .mark_unread': (e,t)-> 
            $(e.currentTarget).closest('.journal_segment').transition('pulse')
            Docs.update @_id, $pull: read_by: Meteor.userId()


    Template.edit_journal.events
        'click #delete_doc': ->
            if confirm 'Delete this journal entry?'
                Docs.remove @_id
                FlowRouter.go '/journal'



if Meteor.isServer
    publishComposite 'journal_templates', (selected_theme_tags, selected_author_ids, view_private, view_unread)->
        {
            find: ->
                self = @
                match = {}
                # match.tags = $all: selected_theme_tags
                if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
                # console.log selected_author_ids
                if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
                # match.published = true
                
                match.type = 'journal'
                
                if view_private is true then match.author_id = Meteor.userId()
                # else if view_private is 'resonates'
                #     match.favoriters = $in: [@userId]
                else if view_private is false then match.published = true
                
                if view_unread is true then match.read_by = $nin: [Meteor.userId()]
                
                
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

    Meteor.publish 'unread_journal_count', ->
        Counts.publish this, 'unread_journal_count', 
            Docs.find(
                type: 'journal' 
                published:true
                read_by: $nin: [Meteor.userId()]
            )
        return undefined    # otherwise coffeescript returns a Counts.publish


    # Meteor.methods
    #     convert_journal_docs: ->
    #         count = Docs.find(
    #             author_id: '2hjhjPYPwxAqxj8BC'
    #             ).count()
    #         console.log count
            
            # Docs.update {
            #     author_id: '2hjhjPYPwxAqxj8BC'
            # }, {
            #     $set: 
            #         author_id: 'FKnvuPnXbtBSPbES5'
            #         type: 'journal'
            # }, multi: true
                