@selected_conversation_tags = new ReactiveArray []
@selected_participant_ids = new ReactiveArray []


Template.conversation_cloud.onCreated ->
    # @autorun -> Meteor.subscribe('tags', selected_conversation_tags.array(), 'conversation')
    @autorun -> Meteor.subscribe('participant_ids', selected_conversation_tags.array(), selected_participant_ids.array())
    Meteor.subscribe 'usernames'

Template.conversation_cloud.helpers
    conversation_tags: ->
        # userCount = Meteor.users.find().count()
        # if 0 < userCount < 3 then tags.find { count: $lt: userCount } else tags.find()
        Tags.find()

    conversation_tag_class: ->
        buttonClass = switch
            when @index <= 10 then 'big'
            when @index <= 20 then 'large'
            when @index <= 30 then ''
            when @index <= 40 then 'small'
            when @index <= 50 then 'tiny'
        return buttonClass

    selected_conversation_tags: -> selected_conversation_tags.list()
    
    participant_tags: ->
        participant_usernames = []
        
        for participant_id in Participant_ids.find().fetch()
            found_user = Meteor.users.findOne(participant_id.text).username
            participant_tag_object = {}
            # if found_user
                # console.log Meteor.users.findOne(participant_id.text).username
            # participant_usernames.push Meteor.users.findOne(participant_id.text).username
            participant_tag_object.username = Meteor.users.findOne(participant_id.text).username
            participant_tag_object.count = participant_id.count
            participant_usernames.push participant_tag_object
        participant_usernames


    selected_participant_ids: ->
        selected_participant_usernames = []
        for selected_participant_id in selected_participant_ids.array()
            selected_participant_usernames.push Meteor.users.findOne(selected_participant_id).username
        selected_participant_usernames
    
    
Template.conversation_cloud.events
    'click .select_tag': -> selected_conversation_tags.push @name
    'click .unselect_tag': -> selected_conversation_tags.remove @valueOf()
    'click #clear_tags': -> selected_conversation_tags.clear()
    
    'click #create_conversation': ->
        id = Docs.insert 
            type: 'conversation'
            participant_ids: [Meteor.userId()]
        FlowRouter.go "/conversation/#{id}"


    'click .select_participant': ->
        selected_participant = Meteor.users.findOne username: @username
        selected_participant_ids.push selected_participant._id
    'click .unselect_participant': -> 
        selected_participant = Meteor.users.findOne username: @valueOf()
        selected_participant_ids.remove selected_participant._id
    'click #clear_participants': -> selected_participant_ids.clear()