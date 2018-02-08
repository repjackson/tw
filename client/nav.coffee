    
Template.layout.events
    'click #logout': -> AccountsTemplates.logout()

# Template.body.events
    # 'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')
    
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'child_docs', '9639QAQ4yPbMLs7CA'
    @autorun -> Meteor.subscribe 'tori_site_doc'

    
    
Template.nav.onRendered ->
    # Meteor.setTimeout =>
    #     $('.ui.dropdown').dropdown()
    # , 1000
    Meteor.setTimeout =>
        $('.item').popup
            position : 'bottom center'
    , 2000
    # Meteor.setTimeout =>
    #     $('.modal').modal({allowMultiple: false})
    # , 1000
    # Meteor.setTimeout =>
    #     $('.confirm.modal').modal('attach events', '.report.modal .ok')
    # , 1000


Template.nav.helpers
    # nav_class: -> 
    #     site_doc = Docs.findOne Session.get('current_site_id')
    #     # console.log 'got site doc', Session.get('current_site_id')
    #     # console.log site_doc.nav
    #     if site_doc
    #         if site_doc.nav.color is 'white' then ''
    #         if site_doc.nav.color is 'black' then 'inverted'
        
    nav_child_items: ->
        site_doc = Docs.findOne '9639QAQ4yPbMLs7CA'
        if site_doc
            Docs.find _id: $in: site_doc.nav.child_ids
        
    site_doc: -> 
        site_doc = Docs.findOne Session.get('current_site_id')
        if site_doc then site_doc

    # bug_link: -> Session.get 'bug_link'


Template.nav.events
    'click #logout': -> AccountsTemplates.logout()
    
    
    
    # 'click #nav_header': ->
    #     FlowRouter.reload() 
        # location.reload()
    # 'click #test': ->
    #     Notification.requestPermission()
    
    "click #report_bug": ->
        Session.set 'bug_link', window.location.pathname
        $('.ui.report.modal').modal(
            inverted: true
            transition: 'horizontal flip'
            # observeChanges: true
            duration: 500
            onApprove : ()->
                val = $("#bug_description").val()
                # window.alert val
                Docs.insert
                    type: 'bug_report'
                    complete: false
                    body: val
                    link: window.location.pathname
                $("#bug_description").val('')
    
                # $('.ui.confirm.modal').modal('show');
            ).modal('show')
        # bug_description = prompt "Please decribe the bug:"


    # 'click #bug_icon': (e,t)->  
    #     console.log e

    # 'click #test': (e,t)->
    #     $(e.currentTarget).closest('#nav_menu').transition('fade right')
    
    
Template.nav.helpers
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
            
        compacted = _.compact ancestors
        if compacted.length > 1
            sorted_ancestors =
                _.sortBy(compacted, (an)->
                    if an.ancestor_array
                        an.ancestor_array.length
                        # an.ancestor_array.length 
                    )
        
        # return ancestors
            
        # console.log cursor.fetch()
        # return cursor
            
            
            
    ancestor: ->
        # console.log 'ancestor', @name
        Docs.findOne @name
            
    # cloud_tag_class: ->
    #     button_class = []
    #     switch
    #         when @index <= 5 then button_class.push ' '
    #         when @index <= 10 then button_class.push 'small'
    #         when @index <= 15 then button_class.push 'tiny '
    #         when @index <= 20 then button_class.push ' mini'
    #     return button_class

    # selected_ancestor_ids: -> selected_ancestor_ids.array()
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






