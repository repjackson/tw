if Meteor.isClient
    Template.member_demo.events
        'click #add_demo_member': ->
            id = Docs.insert type: 'demo_member'
            FlowRouter.go "/edit_profile/#{id}"

    
if Meteor.isServer
    Meteor.publish 'demo_members', (selected_member_demo_tags)->
        match = {}
        if selected_member_demo_tags.length > 0
            match.tags = $all: selected_member_demo_tags
            
        match.type = 'demo_member'
        
        Docs.find match
