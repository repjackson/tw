FlowRouter.route '/profile/:username/comparison', 
    name: 'profile_comparison'
    action: (params) ->
        BlazeLayout.render 'profile_layout',
            sub_nav: 'member_nav'
            profile_content: 'profile_comparison'
    


if Meteor.isClient
    Template.profile_comparison.onCreated -> 
        @autorun -> Meteor.subscribe('user_clouds', FlowRouter.getParam('username'))
        @autorun -> Meteor.subscribe('overlap', selected_theme_tags.array(), FlowRouter.getParam('username'), 'journal')
        # @autorun -> Meteor.subscribe('overlap', selected_theme_tags.array(), FlowRouter.getParam('username'), 'checkin')

    Template.profile_comparison.helpers
        user: -> Meteor.users.findOne username: FlowRouter.getParam('username')
        
        user_authored_list: ->
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            user.authored_list
            
            
        target_docs: -> 
            user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Docs.find( 
                author_id: user._id 
                published: $in:[0,1]
                )
            
        your_docs: -> 
            Docs.find( 
                author_id: Meteor.userId()
                published: $in:[0,1]
                )
            
            
    Template.profile_comparison.events
        'click #calculate_user_clouds': ->
            current_user = Meteor.users.findOne username: FlowRouter.getParam('username')
            Meteor.call 'generate_journal_cloud', current_user._id
            Meteor.call 'generate_checkin_cloud', current_user._id
            