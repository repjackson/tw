if Meteor.isClient
    FlowRouter.route '/course/:slug/members', 
        name: 'course_members'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_members'
                
    @selected_course_member_tags = new ReactiveArray []
                
    
    Template.course_members.onCreated ->
        @autorun -> Meteor.subscribe 'sol_members', FlowRouter.getParam('slug'), selected_course_member_tags.array()
        @autorun -> Meteor.subscribe 'course_member_tags', FlowRouter.getParam('slug'), selected_course_member_tags.array()
        
    Template.course_members.helpers
        course_member_tags: ->
            user_count = Meteor.users.find(_id: $ne:Meteor.userId()).count()
            if 0 < user_count < 3 then People_tags.find({ count: $lt: user_count }, {limit:20}) else People_tags.find({}, limit:20)
            # People_tags.find()
    
        selected_course_member_tags: -> selected_course_member_tags.array()
    
        cloud_tag_class: ->
            button_class = switch
                when @index <= 5 then 'big'
                when @index <= 10 then 'large'
                when @index <= 15 then ''
                when @index <= 20 then 'small'
                when @index <= 25 then 'tiny'
            return button_class


        course_members: ->
            Meteor.users.find
                courses: $in: ['sol', 'sol_demo']


    

    Template.course_members.events
        'click .select_tag': -> selected_course_member_tags.push @name
        'click .unselect_tag': -> selected_course_member_tags.remove @valueOf()
        'click #clear_tags': -> selected_course_member_tags.clear()






    Template.course_member.events
        'click .user_tag': ->
            if @valueOf() in selected_course_member_tags.array() then selected_course_member_tags.remove @valueOf() else selected_course_member_tags.push @valueOf()

    Template.course_member.helpers
        five_tags: -> if @tags then @tags[..4]
    



if Meteor.isServer
    Meteor.publish 'sol_members', (slug, selected_course_member_tags) ->
        match = {}
        if selected_course_member_tags.length > 0 then match.tags = $all: selected_course_member_tags
        match._id = $ne: @userId
        match["profile.published"] = true
        match.courses = $in: [slug]
        
        Meteor.users.find match

        
        
        # Meteor.users.find
        #     # roles: $in: ['sol_member', 'sol_demo_member']
            
            
    Meteor.publish 'course_member_tags', (slug, selected_course_member_tags)->
        self = @
        match = {}
        if selected_course_member_tags.length > 0 then match.tags = $all: selected_course_member_tags
        match._id = $ne: @userId
        # match["profile.published"] = true
        match.courses = $in: [slug]

        # console.log match

        people_cloud = Meteor.users.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $match: _id: $nin: selected_course_member_tags }
            { $sort: count: -1, _id: 1 }
            { $limit: 20 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        # console.log 'cloud, ', people_cloud
        people_cloud.forEach (tag, i) ->
            self.added 'course_member_tags', Random.id(),
                name: tag.name
                count: tag.count
                index: i
    
        self.ready()
        
