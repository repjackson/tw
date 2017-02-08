if Meteor.isClient
    Template.profile_tiles.onCreated ->
        @autorun -> Meteor.subscribe('demo_members', selected_member_demo_tags.array())
    
    
    Template.profile_tiles.helpers
        profiles: -> 
            Docs.find
                type: 'demo_member'


    Template.profile_tile.helpers
        profile_tile_tag_class: -> if @valueOf() in selected_member_demo_tags.array() then 'primary' else 'basic'
    
    

