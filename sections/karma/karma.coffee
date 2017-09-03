if Meteor.isClient
    FlowRouter.route '/karma', action: (params) ->
        BlazeLayout.render 'layout',
            main: 'karma'
    
    
    
    Template.karma.onCreated ->
        @autorun => Meteor.subscribe('my_karma', selected_tags.array())
        @autorun => Meteor.subscribe('bookmarked_tags', selected_tags.array())

        
    Template.karma.onRendered ->

    Template.karma.helpers
        upvoted_docs: -> 
            Docs.find
                author_id: Meteor.userId()
                points: $gt: 0

            
            
    Template.bookmark.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

            
            
    Template.karma.events
        'change #share_karma': (e,t)->
            value = $('#share_karma').is(":checked")
            Meteor.users.update Meteor.userId(), 
                $set:
                    "profile.share_karma": value
    

        'click .select_tag': -> selected_tags.push @name
        'click .unselect_tag': -> selected_tags.remove @valueOf()
        'click #clear_tags': -> selected_tags.clear()

    
            
if Meteor.isServer
    publishComposite 'my_karma', (selected_tags=[])->
        {
            find: ->
                match = {}
                
                if selected_tags.length > 0 then match.tags = $all: selected_tags
                match.points = $gt: 0
                match.author_id = Meteor.userId()
                Docs.find match
            children: [
                { find: (doc) ->
                    Meteor.users.find 
                        _id: $in: [doc.upvoters]
                    }
                ]    
        }
