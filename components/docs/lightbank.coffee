FlowRouter.route '/lightbank', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'lightbank'

if Meteor.isClient
    Template.lightbank.onCreated -> 
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), type=null, filter='lightbank', limit=10)

    Template.lightbank.helpers
        docs: -> 
            Docs.find { }, 
                sort:
                    tag_count: 1
                limit: 10
    
        one_doc: -> 
            Docs.find().count() is 1
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

        selected_tags: -> selected_tags.array()

    
    Template.doc_view.helpers
        is_author: -> Meteor.userId() and @author_id is Meteor.userId()
    
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    
        when: -> moment(@timestamp).fromNow()
        
        lightbank_tags: ->
            _.difference(@tags, 'lightbank')

    Template.doc_view.events
        'click .tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove(@valueOf()) else selected_tags.push(@valueOf())
    
        'click .edit': -> FlowRouter.go("/doc/edit/#{@_id}")
