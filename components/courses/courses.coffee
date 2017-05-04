FlowRouter.route '/courses', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'courses'


Meteor.users.helpers
    course_ob: -> 
        Docs.find
            type: 'course'
            _id: $in: @courses




if Meteor.isClient
    Template.courses.onCreated -> 
        @autorun => Meteor.subscribe('courses', view_mode=Session.get('view_mode'))

    Template.courses.helpers
        courses: -> 
            Docs.find
                type: 'course'
                published: true
    
        all_item_class: -> if Session.equals 'view_mode', 'all' then 'active' else ''
        mine_item_class: -> 
            if Meteor.user()
                if Session.equals 'view_mode', 'mine' then 'active' else ''
            else
                'disabled'
    Template.courses.events
        'click #add_course': ->
            id = Docs.insert
                type: 'course'
                published: false
            FlowRouter.go "/edit/#{id}"
            
        'click #set_mode_to_all': -> 
            if Meteor.userId() then Session.set 'view_mode', 'all'
            else FlowRouter.go '/sign-in'

        'click #set_mode_to_mine': -> 
            if Meteor.userId() then Session.set 'view_mode', 'mine'
            else FlowRouter.go '/sign-in'


if Meteor.isServer
    publishComposite 'course', (course_slug)->
        {
            find: ->
                Docs.find 
                    type: 'course'
                    slug: course_slug
            children: [
                { find: (course) ->
                    Docs.find
                        course: course.slug
                        type: 'module'
                # children: [
                #     {
                #         find: (module) ->
                #             Docs.find 
                #                 _id: module.section_id
                #                 type: 'section'
                #     }
                # ]    
                }
                {
                    find: (course) ->
                        Meteor.users.find course.author_id
                }
            ]
        }            
        
    Meteor.publish 'courses', (view_mode)->
        
        me = Meteor.users.findOne @userId
        self = @
        match = {}
        if view_mode is 'mine'
            match.slug = $in: me.courses
        if not @userId or not Roles.userIsInRole(@userId, ['admin'])
            match.published = true
                
        match.type = 'course'        
                
        Docs.find match