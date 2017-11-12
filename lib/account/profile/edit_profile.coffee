FlowRouter.route '/account/profile/edit/:user_id?', 
    action: (params) ->
        if not params.user_id then FlowRouter.go "/account/profile/edit/#{Meteor.userId()}"
        BlazeLayout.render 'layout',
            main: 'edit_profile'




if Meteor.isClient
    Template.edit_profile.onCreated ->
        @autorun -> Meteor.subscribe 'my_profile', FlowRouter.getParam('user_id') 
    
    # Template.edit_profile.onRendered ->
    #     console.log Meteor.users.findOne(FlowRouter.getParam('user_id'))
    
    Template.edit_profile.helpers
        user: -> Meteor.users.findOne FlowRouter.getParam('user_id')
    
    
    Template.edit_profile.events
        'keydown #input_image_id': (e,t)->
            if e.which is 13
                user_id = FlowRouter.getParam('user_id')
                image_id = $('#input_image_id').val().toLowerCase().trim()
                if image_id.length > 0
                    Meteor.users.update user_id,
                        $set: image_id: image_id
                    $('#input_image_id').val('')
                
                
        'keydown #add_tag': (e,t)->
            if e.which is 13
                tag = $('#add_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Meteor.users.update FlowRouter.getParam('user_id'),
                        $addToSet: tags: tag
                    $('#add_tag').val('')
    
        'click .person_tag': (e,t)->
            tag = @valueOf()
            Meteor.users.update FlowRouter.getParam('user_id'),
                $pull: tags: tag
            $('#add_tag').val(tag)
    
        'click #save_profile': ->
            if Session.get 'enrolling_in', 'sol_demo' 
                user_id = FlowRouter.getParam('user_id')
                Roles.addUsersToRoles user_id, 'sol_demo'
                Meteor.users.update user_id,
                    $addToSet: courses: 'sol'
                Session.set 'enrolling_in', null
            FlowRouter.go "/profile/#{@username}"
    

if Meteor.isServer
    Meteor.publish 'my_profile', ->
        Meteor.users.find @userId,
            fields:
                tags: 1
                profile: 1
                username: 1
                image_id: 1
                courses: 1
    
    
    Meteor.publish 'user_profile', (username)->
        Meteor.users.find username:username,
            fields:
                tags: 1
                profile: 1
                username: 1
                image_id: 1
                courses: 1
                points: 1
                followers: 1