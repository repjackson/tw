@selected_tags = new ReactiveArray []

Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'


Template.theme_facet.helpers
    theme_tags: ->
        
        doc_count = Docs.find({}).count()
        # if selected_tags.array().length
        if 0 < doc_count < 3
            Tags.find { 
                # type:Template.currentData().type
                count: $lt: doc_count
                }, limit:100
        else
            Tags.find({}, limit:100)
            
            
    cloud_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push ' '
            when @index <= 10 then button_class.push 'small'
            when @index <= 15 then button_class.push 'tiny '
            when @index <= 20 then button_class.push ' mini'
        return button_class

    selected_tags: -> selected_tags.array()
    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }



Template.theme_facet.events
    'click .select_theme_tag': -> selected_tags.push @name
    'click .unselect_theme_tag': -> selected_tags.remove @valueOf()
    'click #clear_theme_tags': -> selected_tags.clear()

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_tags.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_tags.push doc.name
        $('#search').val ''


Template.home.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_tags.array()
            # editing = Session.get('editing')

            )
Template.home.onRendered ->

Template.home.helpers
    editing: -> Session.get 'editing'
    
Template.home.events
    'keyup #quick_add': (e,t)->
        e.preventDefault
        tag = $('#quick_add').val().toLowerCase()
        if e.which is 13
            if tag.length > 0
                split_tags = tag.match(/\S+/g)
                $('#quick_add').val('')
                Meteor.call 'add_doc', split_tags
                selected_tags.clear()
                for tag in split_tags
                    selected_tags.push tag




    'click #add': ->
        new_id = 
            Docs.insert
                timestamp: Date.now()
                author_id: Meteor.userId()

        Session.set 'editing', new_id
        
        
Template.delete_button.onCreated ->
    @confirming = new ReactiveVar(false)
            
Template.delete_button.helpers
    confirming: -> Template.instance().confirming.get()

Template.delete_button.events
    'click .delete': (e,t)-> t.confirming.set true

    'click .cancel': (e,t)-> t.confirming.set false
    'click .confirm': (e,t)-> 
        if Session.get 'editing' then Session.set 'editing', null
        Docs.remove @_id
            

    
Template.edit.helpers
    doc: -> Docs.findOne Session.get('editing')
    
Template.edit.events
    'keyup #add_tag': (e,t)->
        e.preventDefault()
        val = $('#add_tag').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update Session.get('editing'),
                        $addToSet: tags: val
                    $('#add_tag').val ''
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(Template.currentData()._id).tags.slice -1
            #         $('#add_tag').val result[0]
            #         Docs.update Template.currentData()._id,
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Session.get('editing'),
            $pull: tags: tag
        $('#add_tag').val(tag)
    
    'click #save': ->
        Session.set 'editing', null