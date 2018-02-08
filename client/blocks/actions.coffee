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

Template.thanks_button.helpers
    said_thanks: -> @upvoters and Meteor.userId() in @upvoters
    thanks_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'blue'
        else 'basic'

# Template.thanks_button.onRendered ->
#     self = @
#     Meteor.setTimeout =>
#         $('#thanks_modal').modal(
#             transition: 'horizontal flip'
#             closable: true
#             inverted: true
#             onApprove : =>
#                 text = $('#thanks_message_text').val()
#                 Meteor.call 'create_message', recipient_id=self.data.author_id, text=text, parent_id=self.data._id, (err,res)->
#                     if err then console.error err
#                     else
#                         $('#message_sent.modal').modal('show')
#                         $('#thanks_message_text').val('')
#             )
#     , 500
    
#     Meteor.setTimeout ->
#         $('#message_sent').modal(
#             transition: 'horizontal flip'
#             inverted: true
#             )
#     , 500

Template.thanks_button.events
    'click .vote_up': (e,t)-> 
        if Meteor.userId()
            # if Meteor.userId() not in @upvoters
                # $('#thanks_modal').modal('show')
            Meteor.call 'vote_up', @_id
            $(e.currentTarget).closest('.vote_up').transition('pulse')
        else FlowRouter.go '/sign-in'



Template.favorite_button.helpers
    favorite_count: -> @favorite_count
    
    favorite_item_class: -> 
        if Meteor.userId()
            if @favoriters and Meteor.userId() in @favoriters then 'red' else 'outline'
        else 'grey disabled'
Template.favorite_button.events
    'click .favorite_item': (e,t)-> 
        if Meteor.userId()
            Meteor.call 'favorite', Template.parentData(0)
            $(e.currentTarget).closest('.favorite_item').transition('pulse')

        else FlowRouter.go '/sign-in'






Template.mark_complete_button.helpers
    complete_button_class: -> 
        if Meteor.user()
            if @completed_ids and Meteor.userId() in @completed_ids then 'inverted' else 'basic'
        else 'grey disabled'
    # completed: -> 
    #     if Meteor.user()
    #         if @completed_ids and Meteor.userId() in @completed_ids then true else false
    #     else false



Template.mark_complete_button.events
    'click .mark_complete': (e,t)-> 
        # console.log Template.parentData(0)
        if Meteor.userId() 
            Meteor.call 'mark_complete', Template.parentData(0)
            $(e.currentTarget).closest('.mark_complete').transition('pulse')
        else FlowRouter.go '/sign-in'


Template.mark_doc_complete_button.helpers
    # complete_button_class: -> if @complete then 'blue' else 'basic'
Template.mark_doc_complete_button.events
    'click .mark_complete': (e,t)-> 
        if @complete is true then Docs.update @_id, $set: complete: false else  Docs.update @_id, $set:complete: true


Template.mark_doc_approved_button.helpers
    # approved_button_class: -> if @approved then 'blue' else 'basic'
Template.mark_doc_approved_button.events
    'click .approve': (e,t)-> 
        if confirm 'Approve Bug?'
            Meteor.call 'approve_bug', @_id, ->
            
    'click .unapprove': ->
        Docs.update @_id, $set: approved: false 
        

Template.bookmark_button.helpers
    bookmark_button_class: -> 
        if Meteor.user()
            if @bookmarked_ids and Meteor.userId() in  @bookmarked_ids then 'blue' else 'basic'
        else 'basic disabled'
        
    bookmarked: -> Meteor.user()?.bookmarked_ids and @_id in Meteor.user().bookmarked_ids


Template.bookmark_button.events
    'click .bookmark_button': (e,t)-> 
        if Meteor.userId() 
            Meteor.call 'bookmark', Template.parentData(0)
            $(e.currentTarget).closest('.bookmark_button').transition('pulse')
        else FlowRouter.go '/sign-in'





Template.pin_button.helpers
    pin_button_class: -> 
        if Meteor.user()
            if @pinned_ids and Meteor.userId() in  @pinned_ids then 'blue' else 'basic'
        else 'grey disabled'
        
    pinned: -> Meteor.user()?.pinned_ids and @_id in Meteor.user().pinned_ids

Template.pin_button.events
    'click .pin_button': (e,t)-> 
        if Meteor.userId() 
            Meteor.call 'pin', Template.parentData(0)
            $(e.currentTarget).closest('.pin_button').transition('pulse')
        else FlowRouter.go '/sign-in'

Template.pin_corner_button.helpers
    pin_button_class: -> 
        if Meteor.user()
            if @pinned_ids and Meteor.userId() in  @pinned_ids then 'blue' else ''
        else 'grey disabled'
        
    pinned: -> Meteor.user()?.pinned_ids and @_id in Meteor.user().pinned_ids


Template.pin_corner_button.events
    'click .pin_button': (e,t)-> 
        if Meteor.userId() 
            Meteor.call 'pin', Template.parentData(0)
            $(e.currentTarget).closest('.pin_button').transition('pulse')
        else FlowRouter.go '/sign-in'



            
Template.reflect_button.events
    'click #reflect': ->
        new_journal_id = Docs.insert
            type:'journal_entry'
            content: ''
            parent_id: @_id
        FlowRouter.go("/edit/#{new_journal_id}")    
        
Template.respond_button.events
    'click #respond': ->
        response_id = Docs.insert
            type:'response'
            content: ''
            parent_id: @_id
        FlowRouter.go("/edit/#{response_id}")    
        
        