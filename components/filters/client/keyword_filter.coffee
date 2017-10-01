@selected_keywords = new ReactiveArray []

Template.keyword_filter.onCreated ->
    @autorun => 
        Meteor.subscribe('watson_keywords', 
            selected_keywords.array()
            selected_author_ids.array()
            type=@data.type
            author_id=@data.author_id
            )

Template.keyword_filter.helpers
    keywords: ->
        doc_count = Docs.find(type:'journal').count()
        # if selected_keywords.array().length
        if 0 < doc_count < 3
            Watson_keywords.find { 
                count: $lt: doc_count
                }, limit:20
        else
            Watson_keywords.find({}, limit:20)
            
            
    cloud_keyword_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push 'large '
            when @index <= 10 then button_class.push ' '
            when @index <= 15 then button_class.push 'small '
            when @index <= 20 then button_class.push ' tiny'
        return button_class

    selected_keywords: -> selected_keywords.array()
    # selected_author_ids: -> selected_author_ids.array()
    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Watson_keywords
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }



Template.keyword_filter.events
    'click .select_keyword': -> selected_keywords.push @name
    'click .unselect_keyword': -> selected_keywords.remove @valueOf()
    'click #clear_keywords': -> selected_keywords.clear()



    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_keywords.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_keywords.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_keywords.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_keywords.push doc.name
        $('#search').val ''
