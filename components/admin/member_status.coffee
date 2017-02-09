# Template.member_status.onCreated ->
#     self = @
#     self.autorun ->
#         self.subscribe 'member_status', FlowRouter.getParam('user_id')


if Meteor.isClient
    Template.member_status.helpers
        status_class: ->
            user = Meteor.users.findOne FlowRouter.getParam('user_id')
            # console.log @
    
    Template.member_status.events
        'click .change_status': (e,t)->
            status = e.currentTarget.dataset.status
            if status is 'part-time'
                day_allotment = 12
            else if status is 'drop-in'
                day_allotment = 2
            console.log day_allotment
            if confirm 'Change Membership Level?'
                if day_allotment
                    Meteor.users.update FlowRouter.getParam('user_id'),
                        $set: 
                            member_status: status
                            day_allotment: day_allotment
                else
                    Meteor.users.update FlowRouter.getParam('user_id'),
                        $set: 
                            member_status: status
                            
                            
Meteor.methods
    'check_in_user': (user_id) ->
        user = Meteor.users.findOne user_id
        Meteor.users.update user_id,
            $set: checked_in: true
        Modules.insert 
            author_id: user_id
            type: 'timecard'
            timestamp: new Date()
            tags: ['timecard', user.name, 'in', Date.now()]
        Meteor.call 'calculate_user_totals', user_id


    'check_out_user': (user_id) ->
        user = Meteor.users.findOne user_id
        Meteor.users.update user_id,
            $set: checked_in: false
        Modules.insert 
            author_id: user_id
            type: 'timecard'
            timestamp: new Date()
            tags: ['timecard', user.name, 'out', Date.now()]
        Meteor.call 'calculate_user_totals', user_id