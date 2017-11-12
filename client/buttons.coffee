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
            

Template.toggle_editing_button.events
    'click #toggle_editing': -> Session.set 'page_editing', true
    'click #toggle_off_editing': -> Session.set 'page_editing', false
    
    
Template.reply_button.events
    'click .reply': ->
        # console.log @
        child_id = Docs.insert
            parent_id: @_id
            type: 'reply'
        Session.set 'inline_editing', child_id

    