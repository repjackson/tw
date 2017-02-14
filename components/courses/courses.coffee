@Courses = new Meteor.Collection 'courses'


FlowRouter.route '/courses', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'courses'

if Meteor.isClient
    Template.courses.onCreated -> 
        # @autorun -> Meteor.subscribe('courses')

    Template.courses.helpers
        # courses: -> 
        #     courses.find { }
    

    

    Template.view.events
    
        # 'click .edit': -> FlowRouter.go("/edit/#{@_id}")

    Template.courses.events
        # 'click #add_module': ->
        #     id = courses.insert({})
        #     FlowRouter.go "/edit_module/#{id}"
    
    


if Meteor.isServer
    # courses.allow
    #     insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    #     update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    #     remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'courses', ()->
    
        self = @
        match = {}
        # selected_tags.push current_herd
        # match.tags = $all: selected_tags
        # if selected_tags.length > 0 then match.tags = $all: selected_tags

        

        Courses.find match
    
    Meteor.publish 'course', (id)->
        Courses.find id
    
