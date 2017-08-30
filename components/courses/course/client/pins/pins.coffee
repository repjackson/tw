FlowRouter.route '/course/sol/pins', 
    name: 'course_pins'
    action: (params) ->
        BlazeLayout.render 'view_course',
            course_content: 'course_pins'



Template.course_pins.onCreated ->
    @autorun => Meteor.subscribe('my_course_pins', selected_tags.array())
    @autorun => Meteor.subscribe('pinned_tags', selected_tags.array())

    
Template.course_pins.onRendered ->

Template.course_pins.helpers
    pinned_tags: ->
        doc_count = Docs.find().count()
        if 0 < doc_count < 3
            Tags.find { 
                count: $lt: doc_count
                }, limit:20
        else
            Tags.find({}, limit:20)
    cloud_tag_class: ->
        button_class = []
        switch
            when @index <= 5 then button_class.push ' '
            when @index <= 10 then button_class.push ' small'
            when @index <= 15 then button_class.push ' tiny'
            when @index <= 20 then button_class.push ' mini'
        return button_class

    selected_tags: -> selected_tags.array()


    pinned_docs: -> 
        Docs.find
            pinned_ids: $in: [Meteor.userId()]

    pins_count: ->
        Docs.find(pinned_ids: $in: [Meteor.userId()]).count()
        
        
Template.bookmark.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

        
        
Template.course_pins.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()

