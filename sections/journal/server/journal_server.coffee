    
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
