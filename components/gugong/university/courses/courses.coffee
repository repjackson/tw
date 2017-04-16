FlowRouter.route '/ucourses', action: ->
    BlazeLayout.render 'layout', 
        sub_nav: 'gugong_nav'
        main: 'ucourses'

FlowRouter.route '/ucourse/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'gugong_nav'
        main: 'edit_ucourse'

FlowRouter.route '/ucourse/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'gugong_nav'
        main: 'ucourse_page'



if Meteor.isClient
    Template.edit_ucourse.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.edit_ucourse.helpers
        ucourse: -> Docs.findOne FlowRouter.getParam('doc_id')
        
    Template.ucourses.onCreated ->
        @autorun -> Meteor.subscribe('selected_ucourses', selected_tags.array())
    
    
    Template.ucourse_page.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    
    
    Template.ucourse_page.helpers
        ucourse: ->
            Docs.findOne FlowRouter.getParam('doc_id')
    
    
    Template.ucourse_page.events
        'click .edit_ucourse': ->
            FlowRouter.go "/ucourse/edit/#{@_id}"
    
    
    
    
    Template.ucourses.helpers
        ucourses: -> 
            Docs.find {
                type: 'ucourse'
                }
                
    Template.ucourses.events
        'click #add_ucourse': ->
            id = Docs.insert
                type: 'ucourse'
            FlowRouter.go "/ucourse/edit/#{id}"
    
    
    
    
    
        
    Template.ucourse_item.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'
    
        can_edit: -> @author_id is Meteor.userId()
    
        


    Template.ucourse_item.events
        'click .ucourse_tag': ->
            if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()
    
        'click .edit_ucourse': ->
            FlowRouter.go "/ucourse/edit/#{@_id}"


if Meteor.isServer
    Meteor.publish 'selected_ucourses', (selected_ucourse_tags)->
        
        self = @
        match = {}
        if selected_ucourse_tags.length > 0 then match.tags = $all: selected_ucourse_tags
        match.type = 'ucourse'
        # if not @userId or not Roles.userIsInRole(@userId, ['admin'])
        #     match.published = true
        
    
        Docs.find match
    
    Meteor.publish 'ucourse', (doc_id)->
        Docs.find doc_id
    
        
