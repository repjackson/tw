if Meteor.isClient
    FlowRouter.route '/colors', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            main: 'colors'
    
    
    
    Template.colors.onCreated -> 
        @autorun -> Meteor.subscribe('docs', ['colors'])


    Template.colors.events
        'click #add_color': ->
            id = Docs.insert tags: ['colors']
            FlowRouter.go "/edit/#{id}"

        'click .decrease_index': ->
            console.log @
            
            


    Template.colors.helpers
        colors: -> 
            Docs.find()

        my_number: ->
            # console.log @tags

        personality_color: ->
            # console.log @tags
            
            color_tag = _.difference @tags, 'colors'
            
            console.log color_tag
            Docs.find 
                tags: $in: 'personality_color', 'ranking', color_tag
    
if Meteor.isServer
    Meteor.publish 'personality_colors', ->
        Docs.find
            tags: $in: ['personality_color']