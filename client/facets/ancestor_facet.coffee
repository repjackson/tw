@selected_ancestor_ids = new ReactiveArray []

Template.ancestor_facet.helpers
    ancestors: ->
        
        # doc_count = Docs.find().count()
        # # if selected_ancestor_ids.array().length
        # if 0 < doc_count < 3
        #     Ancestor_ids.find { 
        #         # type:Template.currentData().type
        #         count: $lt: doc_count
        #         }, limit:20
        # else
        cursor = Ancestor_ids.find({}, 
            limit:20, 
            # sort:ancestor_array.length
            )
        ancestors = []
        ancestor_ids = Ancestor_ids.find({}).fetch()
        for ancestor_id in ancestor_ids
            # console.log ancestor_id
            ancestors.push Docs.findOne ancestor_id.name
            
        # console.dir ancestors
        # if ancestors.length > 0
        #     sorted_ancestors =
        #         _.sortBy(ancestors, (an)->
        #             if an.ancestor_array
        #                 an.ancestor_array?.length
        #             # an.ancestor_array.length 
        #             )
        
        return ancestors
            
        # console.log cursor.fetch()
        # return cursor
            
            
            
    ancestor: ->
        # console.log 'ancestor', @name
        Docs.findOne @name
            
    cloud_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push ' '
            when @index <= 10 then button_class.push 'small'
            when @index <= 15 then button_class.push 'tiny '
            when @index <= 20 then button_class.push ' mini'
        return button_class

    selected_ancestor_ids: -> selected_ancestor_ids.array()
    # settings: -> {
    #     position: 'bottom'
    #     limit: 10
    #     rules: [
    #         {
    #             collection: Tags
    #             field: 'name'
    #             matchAll: false
    #             template: Template.tag_result
    #         }
            # ]
    # }



Template.ancestor_facet.events
    'click .select_ancestor_id': -> selected_ancestor_ids.push @name
    'click .unselect_ancestor_id': -> selected_ancestor_ids.remove @valueOf()
    'click #clear_ancestor_ids': -> selected_ancestor_ids.clear()

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_ancestor_ids.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_ancestor_ids.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_ancestor_ids.pop()
                    
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        selected_ancestor_ids.push doc.name
        $('#search').val ''
