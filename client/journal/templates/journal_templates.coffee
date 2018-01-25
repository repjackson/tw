if Meteor.isClient
    Template.journal_template.onCreated -> 
        Meteor.subscribe 'author', @data._id
        Meteor.subscribe 'child_docs', @data._id
    # Template.view_journal_templates.onCreated -> 
    #     self = @
    #     @autorun => 
    #     Meteor.subscribe('facet', 
    #         selected_theme_tags.array()
    #         selected_author_ids.array()
    #         selected_location_tags.array()
    #         selected_intention_tags.array()
    #         selected_timestamp_tags.array()
    #         type='journal_template'
    #         author_id=null
    #         parent_id=null
    #         tag_limit=20
    #         doc_limit=20
    #         view_published= Session.get 'view_published'
    #         view_read=null
    #         view_bookmarked= Session.get 'view_bookmarked'
    #         view_resonates=null
    #         view_complete=null
    #         view_images=null
    #         view_lightbank_type=null

    #         )
            
    # Template.view_journal.onCreated ->
    #     Meteor.setTimeout ->
    #         $('.progress').progress()
    #     , 2000

    
    Template.journal_template.onRendered ->
        @autorun =>
            if @subscriptionsReady()
                Meteor.setTimeout ->
                    $('.ui.accordion').accordion()
                , 500

    
    Template.view_journal_templates.helpers
        journal_templates: -> 
            match = {}
            match.type = 'journal_template'
            Docs.find match, 
                sort:
                    timestamp: -1
    
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
            
        journal_card_class: -> if @published then 'blue' else ''
        
    Template.journal_template.helpers
        tag_class: -> if @valueOf() in selected_theme_tags.array() then 'teal' else 'basic'
        journal_card_class: -> if @published then 'blue' else ''
        journal_template_sections: ->
            Docs.find {
                type: 'journal_template_section'
                parent_id: @_id
                }, sort: number: 1

    Template.journal_template.events
        'click .tag': -> if @valueOf() in selected_theme_tags.array() then selected_theme_tags.remove(@valueOf()) else selected_theme_tags.push(@valueOf())



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
                