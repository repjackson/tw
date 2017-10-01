publishComposite 'journal_docs', (selected_theme_tags, selected_author_ids, selected_location_tags, selected_intention_tags, view_private, view_unread)->
    {
        find: ->
            self = @
            match = {}
            # match.tags = $all: selected_theme_tags
            if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
            # console.log selected_author_ids
            if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids
            # match.published = true
            if selected_intention_tags.length > 0 then match.intention_tags = $in: selected_intention_tags
            if selected_location_tags.length > 0 then match.location_tags = $in: selected_location_tags
            
            match.type = 'journal'

            if view_private is true then match.author_id = Meteor.userId()
            # else if view_private is 'resonates'
            #     match.favoriters = $in: [@userId]
            else if view_private is false then match.published = true
            
            if view_unread is true then match.read_by = $nin: [Meteor.userId()]
            
            console.log 'journal match', match
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
    
    
    
publishComposite 'journal_prompts', (selected_theme_tags)->
    {
        find: ->
            match = {}
            selected_theme_tags.push 'journal prompt'
            match.tags = $all: selected_theme_tags
            
            match.type = 'lightbank'
            
            
            Docs.find match,
                sort: timestamp: -1
            
            
        children: [
            {
                find: (doc)->
                    Meteor.users.find
                        _id: doc.author_id
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
            