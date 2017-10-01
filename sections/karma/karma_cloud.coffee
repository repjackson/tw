if Meteor.isClient
    @selected_karma_tags = new ReactiveArray []
    @selected_upvoter_ids = new ReactiveArray []
    
    
    Template.karma_cloud.onCreated ->
        @autorun -> Meteor.subscribe('karma_tags', selected_karma_tags.array(), selected_upvoter_ids.array())
        @autorun -> Meteor.subscribe('upvoter_ids', selected_karma_tags.array(), selected_upvoter_ids.array())
        Meteor.subscribe 'usernames'
    
    Template.karma_cloud.helpers
        karma_tags: ->
            # userCount = Meteor.users.find().count()
            # if 0 < userCount < 3 then tags.find { count: $lt: userCount } else tags.find()
            Tags.find()
    
        karma_tag_class: ->
            buttonClass = switch
                when @index <= 5 then ''
                when @index <= 12 then 'small'
                when @index <= 20 then 'mini'
            return buttonClass
    
        selected_karma_tags: -> selected_karma_tags.list()
        
        upvoter_tags: ->
            upvoter_usernames = []
            
            for upvoter_id in Upvoter_ids.find().fetch()
                # console.log upvoter_id
                found_user = Meteor.users.findOne(upvoter_id.text)
                upvoter_tag_object = {}
                if found_user
                    # console.log Meteor.users.findOne(upvoter_id.text).username
                # upvoter_usernames.push Meteor.users.findOne(upvoter_id.text).username
                    upvoter_tag_object.username = Meteor.users.findOne(upvoter_id.text).username
                    upvoter_tag_object.count = upvoter_id.count
                    upvoter_usernames.push upvoter_tag_object
            upvoter_usernames
    
    
        selected_upvoter_ids: ->
            selected_upvoter_usernames = []
            for selected_upvoter_id in selected_upvoter_ids.array()
                selected_upvoter_usernames.push Meteor.users.findOne(selected_upvoter_id).username
            selected_upvoter_usernames
        
        
    Template.karma_cloud.events
        'click .select_tag': -> selected_karma_tags.push @name
        'click .unselect_tag': -> selected_karma_tags.remove @valueOf()
        'click #clear_tags': -> selected_karma_tags.clear()
        
    
        'click .select_upvoter': ->
            selected_upvoter = Meteor.users.findOne username: @username
            selected_upvoter_ids.push selected_upvoter._id
        'click .unselect_upvoter': -> 
            selected_upvoter = Meteor.users.findOne username: @valueOf()
            selected_upvoter_ids.remove selected_upvoter._id
        'click #clear_upvoters': -> selected_upvoter_ids.clear()
        
        
if Meteor.isServer
    publishComposite 'upvoter_ids', (selected_theme_tags, selected_upvoter_ids)->
        
        {
            find: ->
                self = @
                match = {}
                # console.log selected_upvoter_ids
                # console.log selected_theme_tags
                if selected_theme_tags.length > 0 then match.tags = $all: selected_theme_tags
                if selected_upvoter_ids.length > 0 then match.upvoters = $in: selected_upvoter_ids
                match.author_id = Meteor.userId()
                
                cloud = Docs.aggregate [
                    { $match: match }
                    { $project: upvoters: 1 }
                    { $unwind: "$upvoters" }
                    { $group: _id: '$upvoters', count: $sum: 1 }
                    { $match: _id: $nin: selected_upvoter_ids }
                    { $sort: count: -1, _id: 1 }
                    { $limit: 20 }
                    { $project: _id: 0, text: '$_id', count: 1 }
                    ]
            
            
                # console.log cloud
                
                # author_objects = []
                # Meteor.users.find _id: $in: cloud.
            
                cloud.forEach (upvoter_ids) ->
                    self.added 'upvoter_ids', Random.id(),
                        text: upvoter_ids.text
                        count: upvoter_ids.count
                self.ready()
            
            # children: [
            #     { find: (doc) ->
            #         Meteor.users.find 
            #             _id: doc.upvoter_ids
            #         }
            #     ]    
        }            
        
