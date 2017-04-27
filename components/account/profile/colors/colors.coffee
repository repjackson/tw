if Meteor.isClient
    FlowRouter.route '/colors', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            main: 'colors'
    
    
    
    Template.colors.onCreated -> 
        @autorun -> Meteor.subscribe('personality_colors')


    Template.colors.events
        'click #add_color': ->
            id = Docs.insert type: 'personality_color'
            FlowRouter.go "/edit/#{id}"

        'click .increase_index': ->
            if Meteor.user().profile.colors
                colors = Meteor.user().profile.colors
                current_index = colors.indexOf @valueOf() 
                new_index = current_index - 1
        	    colors.splice(new_index, 0, colors.splice(current_index, 1)[0] )
        	    Meteor.users.update Meteor.userId(),
        	        $set: "profile.colors": colors

            
        'click #generate_colors': ->
            Meteor.users.update Meteor.userId(),
                $set:
                    "profile.colors": ['gold', 'green', 'blue', 'orange']

    Template.color_dots.helpers
        user: ->
            console.log @profile.colors
    
        color_icon_class: ->
            icon_class = switch @valueOf()
                when 'gold' then 'yellow' 
                when 'blue' then 'blue' 
                when 'green' then 'green' 
                when 'orange' then 'orange'
            icon_class

    Template.colors.helpers
        colors: -> Docs.find type: 'personality_color'
        color_segment_class: ->
            segment_class = switch @valueOf()
                when 'gold' then 'yellow' 
                when 'blue' then 'blue' 
                when 'green' then 'green' 
                when 'orange' then 'orange'
            segment_class
        
        me: -> Meteor.user()
    
if Meteor.isServer
    publishComposite 'personality_colors', ->
        {
            find: ->
                Docs.find
                    type: 'personality_color'
            children: [
                { find: (personality_color) ->
                    Docs.find 
                        parent_id: personality_color._id
                        author_id: @userId
                        type: 'rank'
                    }
                ]    
        }
