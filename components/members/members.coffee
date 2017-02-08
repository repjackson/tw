FlowRouter.route '/members', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        # sub_nav: 'admin_nav'
        main: 'members'
 
 



if Meteor.isClient
    Template.members.onCreated ->
        @autorun -> Meteor.subscribe('members', selected_tags.array())
    
    
    Template.members.helpers
        members: -> 
            Meteor.users.find { _id: $ne: Meteor.userId() }, 
                # sort:
                #     tag_count: 1
                #     points: -1
                limit: 10
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else ''
    
if Meteor.isServer    
    Meteor.publish 'members', (selected_tags)->
        match = {}
        if selected_tags.length > 0 then match.tags = $all: selected_tags
        # match.tags = $all: selected_tags
        match._id = $ne: @userId
        # match.checked_in = true
        
        Meteor.users.find match,
            fields:
                tags: 1
                username: 1
                image_id: 1
                name: 1
                emails: 1
                checked_in: 1
                profile: 1
            # ,
            # limit: 4
    
    
    
    Meteor.publish 'profile', (id)->
        Meteor.users.find id,
            fields:
                tags: 1
                username: 1
                image_id: 1
                name: 1
                profile: 1
                emails: 1
                checked_in: 1
                monthly_day_usage: 1
                checkins_this_month: 1
                member_status: 1
                day_allotment: 1
                member_type: 1
    
    Meteor.publish 'user_names', ->
        Meteor.users.find {},
            fields: 
                name: 1
                member_status: 1
