Meteor.publish 'unpublished_lightbank_count', ->
    Counts.publish this, 'unpublished_lightbank_count', Docs.find(type: 'lightbank', published:false)
    return undefined    # otherwise coffeescript returns a Counts.publish
Meteor.publish 'published_lightbank_count', ->
    Counts.publish this, 'published_lightbank_count', Docs.find(type: 'lightbank', published:true)
    return undefined    # otherwise coffeescript returns a Counts.publish
Meteor.publish 'unread_lightbank_count', ->
    Counts.publish this, 'unread_lightbank_count', 
        Docs.find(
            type: 'lightbank' 
            published:true
            read_by: $nin: [Meteor.userId()]
        )
    return undefined    # otherwise coffeescript returns a Counts.publish
