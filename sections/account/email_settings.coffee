        
        
if Meteor.isClient
    FlowRouter.route '/profile/:username/email_settings', action: (params) ->
        BlazeLayout.render 'profile_layout',
            sub_nav: 'member_nav'
            profile_content: 'email_settings'
    
    
    Template.email_settings.onCreated ->
        @autorun -> Meteor.subscribe 'my_profile', FlowRouter.getParam('user_id') 
    
    Template.email_settings.onRendered ->
        Meteor.setTimeout (->
            $('.ui.checkbox').checkbox()
        ), 1000
    
    Template.email_settings.helpers
        toggle_class: ->
            if Meteor.user().profile.settings.email.unsubscribe_all then 'disabled' else ''
    
    Template.email_settings.events
    	'mouseenter .large.icons': -> $( ".corner.icon" ).addClass( "loading" )

    	'mouseleave .large.icons': -> $( ".corner.icon" ).removeClass( "loading" )
    
    
    
    
        'click .announcements_toggle': ->
            current_announcements_value = Meteor.user().profile.settings?.email?.announcements
            if current_announcements_value
                new_value = !current_announcements_value
            else 
                new_value = true
            Meteor.users.update Meteor.userId(), 
                $set:
                    "profile.settings.email.announcements": new_value

    
        'click .new_features_toggle': ->
            current_new_features_value = Meteor.user().profile.settings?.email?.new_features
            if current_new_features_value
                new_value = !current_new_features_value
            else 
                new_value = true
            Meteor.users.update Meteor.userId(), 
                $set:
                    "profile.settings.email.new_features": new_value

    
        'click .unsubscribe_toggle': ->
            current_unsubscribe_all_value = Meteor.user().profile.settings?.email?.unsubscribe_all
            if current_unsubscribe_all_value
                new_value = !current_unsubscribe_all_value
            else 
                new_value = true

            Meteor.users.update Meteor.userId(), 
                $set:
                    "profile.settings.email.unsubscribe_all": new_value
            $('.other_segment').transition('shake')

    
        'change #newsletter': (e,t)->
            # console.log e.currentTarget.value
            value = $('#newsletter').is(":checked")
            Meteor.users.update FlowRouter.getParam('user_id'), 
                $set:
                    "profile.subscribe": value
    
