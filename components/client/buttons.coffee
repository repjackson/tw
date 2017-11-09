Template.published.helpers
    published_class: -> if @published is 1 then 'blue' else 'basic'
    published_anonymously_class: -> if @published is 0 then 'blue' else 'basic'
    private_class: -> if @published is -1 then 'blue' else 'basic'
    is_published: -> @published is 1
    published_anonymously: -> @published is 0
    is_private: -> @published is -1

Template.published.events
    'click #publish': (e,t)-> 
        Docs.update @_id, $set: published: 1
    'click #unpublish': (e,t)-> 
        Docs.update @_id, $set: published: -1
    'click #publish_anonymously': ->
        Docs.update @_id, $set: published: 0
        
        
        
Template.voting.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'

Template.voting.events
    'click .vote_up': (e,t)-> 
        if Meteor.userId()
            Meteor.call 'vote_up', @_id
            $(e.currentTarget).closest('.vote_up').transition('pulse')
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() 
            Meteor.call 'vote_down', @_id
            $(e.currentTarget).closest('.vote_down').transition('pulse')
        else FlowRouter.go '/sign-in'
        
        
        
Template.edit_button.onCreated ->
    @editing = new ReactiveVar(false)
Template.edit_button.helpers
    editing: -> Template.instance().editing.get()

Template.edit_button.events
    'click .edit_this': (e,t)-> 
        console.log @
        console.log t.editing
        t.editing.set true
    'click .save_doc': (e,t)-> 
        console.log t.editing
        t.editing.set false



Template.session_edit_button.events
    'click .edit_this': -> Session.set 'inline_editing', @_id
    'click .save_doc': -> Session.set 'inline_editing', null

Template.delete_button.onCreated ->
    @confirming = new ReactiveVar(false)
            
Template.delete_button.helpers
    confirming: -> Template.instance().confirming.get()

Template.delete_button.events
    'click .delete': (e,t)-> t.confirming.set true

    'click .cancel': (e,t)-> t.confirming.set false
    'click .confirm': (e,t)-> 
        if Session.get 'inline_editing' then Session.set 'inline_editing', null
        Docs.remove @_id
            
Template.delete_link.onCreated ->
    @confirming = new ReactiveVar(false)
            
            
Template.delete_link.helpers
    confirming: -> Template.instance().confirming.get()

Template.delete_link.events
    'click .delete': (e,t)-> 
        # $(e.currentTarget).closest('.comment').transition('pulse')
        t.confirming.set true

    'click .cancel': (e,t)-> t.confirming.set false
    'click .confirm': (e,t)-> 
        $(e.currentTarget).closest('.comment').transition('fade right')
        Meteor.setTimeout =>
            Docs.remove(@_id)
        , 1000


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
            if @completed_ids and Meteor.userId() in @completed_ids then 'basic' else 'basic'
        else 'grey disabled'
    completed: -> 
        if Meteor.user()
            if @completed_ids and Meteor.userId() in @completed_ids then true else false
        else false
Template.mark_complete_button.events
    'click .mark_complete': (e,t)-> 
        if Meteor.userId() 
            Meteor.call 'mark_complete', Template.parentData(0)
            $(e.currentTarget).closest('.mark_complete').transition('pulse')
        else FlowRouter.go '/sign-in'


Template.mark_doc_complete_button.helpers
    # complete_button_class: -> if @complete then 'blue' else 'basic'
Template.mark_doc_complete_button.events
    'click .mark_complete': (e,t)-> 
        if @complete is true then Docs.update @_id, $set: complete: false else  Docs.update @_id, $set:complete: true


Template.bookmark_button.helpers
    bookmark_button_class: -> 
        if Meteor.user()
            if @bookmarked_ids and Meteor.userId() in  @bookmarked_ids then 'teal' else 'basic'
        else 'basic disabled'
        
    bookmarked: -> Meteor.user()?.bookmarked_ids and @_id in Meteor.user().bookmarked_ids


Template.bookmark_button.events
    'click .bookmark_button': (e,t)-> 
        if Meteor.userId() 
            Meteor.call 'bookmark', Template.parentData(0)
            $(e.currentTarget).closest('.bookmark_button').transition('pulse')
        else FlowRouter.go '/sign-in'




Template.toggle_editing_button.events
    'click #toggle_editing': -> Session.set 'page_editing', true
    'click #toggle_off_editing': -> Session.set 'page_editing', false