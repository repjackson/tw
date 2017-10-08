    
Meteor.publish 'unread_journal_count', ->
    Counts.publish this, 'unread_journal_count', 
        Docs.find(
            type: 'journal' 
            published:true
            read_by: $nin: [Meteor.userId()]
        )
    return undefined    # otherwise coffeescript returns a Counts.publish
