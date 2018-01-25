Template.volunteer.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000


Template.volunteer.onCreated -> 
    @autorun -> Meteor.subscribe('facet', selected_theme_tags.array(), 'shift')

Template.volunteer.helpers
    shifts: -> 
        Docs.find { type:'shift' }, 
            sort:
                date: 1
                
    formatted_date: -> moment(@date).format("dddd, MMMM Do")
               
    volunteer: -> Meteor.users.findOne @valueOf()
               
    signed_up_for_first: -> Meteor.userId() in @volunteers


Template.volunteer.events
    'click #add_shift': -> 
        id = Docs.insert 
            type:'shift'
            openings: 4
            volunteer_id: []
        FlowRouter.go "/shift/#{id}"

                    

Template.shift.helpers
    first_shift_button_class: -> if @shift is 'first' then 'blue' else 'basic'
    second_shift_button_class: -> if @shift is 'second' then 'blue' else 'basic'

Template.volunteer_list.helpers
    volunteers: -> Meteor.users.find( _id: $in: @participants).fetch()



Template.shift.events
    'click #make_first_shift': -> 
        Docs.update FlowRouter.getParam('doc_id'),
            $set: shift: 'first'
            
    'click #make_second_shift': -> 
        Docs.update FlowRouter.getParam('doc_id'),
            $set: shift: 'second'
            
