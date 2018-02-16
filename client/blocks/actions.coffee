Template.action.helpers
    action_doc: -> 
        # console.log @
        action_doc = Docs.findOne @valueOf()
        
        
    action_button_class: -> 
        target_doc = Template.parentData(1)
        action_doc = Docs.findOne @valueOf()
        if target_doc["#{action_doc.slug}"] and Meteor.userId() in target_doc["#{action_doc.slug}"] then '' else 'basic'
        
Template.action.events
    'click .toggle_action': (e,t)-> 
        action_doc = Docs.findOne @valueOf()
        # console.log action_doc
        target_doc = Template.parentData(1)
        if target_doc["#{action_doc.slug}"]
            if Meteor.userId() in target_doc["#{action_doc.slug}"]
                Docs.update target_doc._id,
                    $pull: "#{action_doc.slug}":Meteor.userId()
            else
                Docs.update target_doc._id,
                    $addToSet: "#{action_doc.slug}":Meteor.userId()
        else
            Docs.update target_doc._id,
                $addToSet: "#{action_doc.slug}":Meteor.userId()



Template.vote_button.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'

Template.vote_button.events
    'click .vote_up': (e,t)-> 
        if Meteor.userId()
            Meteor.call 'vote_up', @_id
            $(e.currentTarget).closest('.vote_up').transition('pulse')
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() then Meteor.call 'vote_down', @_id
        else FlowRouter.go '/sign-in'

        
Template.respond_button.events
    'click #respond': ->
        response_id = Docs.insert
            type:'response'
            content: ''
            parent_id: @_id
        FlowRouter.go("/edit/#{response_id}")    
        
        
        
Template.read_by_list.onCreated ->
    @autorun => Meteor.subscribe 'read_by', Template.parentData()._id
    
Template.read_by_list.helpers
    read_by: ->
        if @read_by
            if @read_by.length > 0
        # console.log @read_by
                Meteor.users.find _id: $in: @read_by
        else 
            false
            
    
    
    
    
Template.notify_button.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 500



Template.notify_button.onCreated ->
    Meteor.subscribe 'usernames'

Template.notify_button.events
    "autocompleteselect input": (event, template, selected_user) ->
        # console.log("selected ", doc)
        context_doc = Template.parentData(4)
        Meteor.call 'notify_user_about_document', context_doc._id, selected_user._id, =>
            Bert.alert "#{selected_user.name()} was notified.", 'info', 'growl-top-right'

        Docs.update context_doc._id,
            $addToSet: notified_ids: selected_user._id
        $('#recipient_select').val("")


    'click .remove_notified_user': ->
        context_doc = Template.parentData(4)
        Meteor.call 'remove_notification', context_doc._id, @_id, =>
            Bert.alert "#{@name()} was unnotified.", 'info', 'growl-top-right'
        Docs.update context_doc._id,
            $pull: notified_ids: @_id
        


Template.notify_button.helpers
    recipient_select_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }




