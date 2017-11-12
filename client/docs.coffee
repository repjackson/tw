FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'home'
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
                }, limit:50
        else
            Tags.find({}, limit:50)
            
            
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
    # @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'doc', Session.get('inline_editing')
    # @autorun -> Meteor.subscribe 'my_children', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'usernames'
    # @autorun -> Meteor.subscribe 'components'
    @autorun => 
        Meteor.subscribe('facet', 
            selected_tags.array()
            # inline_editing = Session.get('inline_editing')

            )
Template.home.onRendered ->

Template.home.helpers
    children: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc
            if Session.get 'inline_editing'
                Docs.find Session.get('inline_editing')
            
            else
                Docs.find {
                    }, {
                        sort: { timestamp: -1, points: -1, number: 1  }
                        }
    
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




    'click #user_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        Session.set 'inline_editing', new_id
        
        
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update Template.currentData()._id,
            $addToSet: tags: doc.name
        Meteor.call 'calculate_tag_count', Template.currentData()._id

        $('#theme_tag_select').val('')
   
    'keyup #theme_tag_select': (e,t)->
        e.preventDefault()
        val = $('#theme_tag_select').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update Template.currentData()._id,
                        $addToSet: tags: val
                    $('#theme_tag_select').val ''
                    Meteor.call 'calculate_tag_count', Template.currentData()._id
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(Template.currentData()._id).tags.slice -1
            #         $('#theme_tag_select').val result[0]
            #         Docs.update Template.currentData()._id,
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: tags: tag
        $('#theme_tag_select').val(tag)
        