@Tags = new Meteor.Collection 'tags'
@People_tags = new Meteor.Collection 'people_tags'
@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)->
    doc.timestamp = Date.now()
    doc.author_id = Meteor.userId()
    doc.tag_count = doc.tags?.length
    doc.points = 0
    doc.upvoters = []
    # doc.downvoters = []
    doc.published = false
    return


# Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
#     doc.tag_count = doc.tags.length
#     # console.log doc
# ), fetchPrevious: true


# Docs.before.update (userId, doc, fieldNames, modifier, options) ->
#   modifier.$set = modifier.$set or {}
#   modifier.$set.tag_count = doc.tags.length
#   return



Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    parent: -> Docs.findOne @parent_id



Meteor.methods
    add: (tags=[])->
        id = Docs.insert {}
        return id
    add_checkin: (tags=[])->
        id = Docs.insert
            tags: tags
            type: 'checkin'
        return id





FlowRouter.route '/sol',
  triggersEnter: [ (context, redirect) ->
    redirect '/course/sol'
    return
 ]

FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'


FlowRouter.route '/', action: ->
    BlazeLayout.render 'layout', 
        main: 'home'


FlowRouter.route '/contact', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'contact'

FlowRouter.route '/about', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'about'



Meteor.users.helpers
    course_ob: -> 
        Docs.find
            type: 'course'
            _id: $in: @courses






Meteor.users.helpers
    name: -> 
        if @profile?.first_name and @profile?.last_name
            "#{@profile.first_name}  #{@profile.last_name}"
        else
            "#{@username}"
    last_login: -> 
        moment(@status?.lastLogin.date).fromNow()

    five_tags: -> @tags[0..3]
    
            
            
Meteor.methods
    vote_up: (id)->
        doc = Docs.findOne id
        if not doc.upvoters
            Docs.update id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in doc.upvoters #undo upvote
            Docs.update id,
                $pull: upvoters: Meteor.userId()
                $inc: points: -1
            Meteor.users.update doc.author_id, $inc: points: -1
            # Meteor.users.update Meteor.userId(), $inc: points: 1

        # else if Meteor.userId() in doc.downvoters #switch downvote to upvote
        #     Docs.update id,
        #         $pull: downvoters: Meteor.userId()
        #         $addToSet: upvoters: Meteor.userId()
        #         $inc: points: 2
        #     Meteor.users.update doc.author_id, $inc: points: 2

        else #clean upvote
            Docs.update id,
                $addToSet: upvoters: Meteor.userId()
                $inc: points: 1
            Meteor.users.update doc.author_id, $inc: points: 1
            # Meteor.users.update Meteor.userId(), $inc: points: -1
        Meteor.call 'generate_upvoted_cloud', Meteor.userId()


    vote_down: (id)->
        doc = Docs.findOne id
        if not doc.downvoters
            Docs.update id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in doc.downvoters #undo downvote
            Docs.update id,
                $pull: downvoters: Meteor.userId()
                $inc: points: 1
            Meteor.users.update doc.author_id, $inc: points: 1
            # Meteor.users.update Meteor.userId(), $inc: points: 1

        else if Meteor.userId() in doc.upvoters #switch upvote to downvote
            Docs.update id,
                $pull: upvoters: Meteor.userId()
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -2
            Meteor.users.update doc.author_id, $inc: points: -2

        else #clean downvote
            Docs.update id,
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -1
            Meteor.users.update doc.author_id, $inc: points: -1
            # Meteor.users.update Meteor.userId(), $inc: points: -1
        Meteor.call 'generate_downvoted_cloud', Meteor.userId()


    favorite: (doc)->
        if doc.favoriters and Meteor.userId() in doc.favoriters
            Docs.update doc._id,
                $pull: favoriters: Meteor.userId()
                $inc: favorite_count: -1
        else
            Docs.update doc._id,
                $addToSet: favoriters: Meteor.userId()
                $inc: favorite_count: 1
    
    
    mark_complete: (doc)->
        if Meteor.user().completed_ids and doc._id in Meteor.user().completed_ids
            Meteor.users.update Meteor.userId(),
                $pull: completed_ids: doc._id
        else
            Meteor.users.update Meteor.userId(),
                $addToSet: completed_ids: doc._id
    
    
    bookmark: (doc)->
        if Meteor.user().bookmarked_ids and doc._id in Meteor.user().bookmarked_ids
            Meteor.users.update Meteor.userId(),
                $pull: bookmarked_ids: doc._id
        else
            Meteor.users.update Meteor.userId(),
                $addToSet: bookmarked_ids: doc._id
