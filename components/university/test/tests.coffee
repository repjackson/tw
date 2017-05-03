if Meteor.isClient
    FlowRouter.route '/tests', action: ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            # sub_sub_nav: 'inspire_u_nav'
            main: 'tests'
    
    FlowRouter.route '/test/:doc_id/view', 
        name: 'view_test'
        action: (params) ->
            BlazeLayout.render 'layout',
                sub_nav: 'member_nav'
                main: 'test_page'
    
    
    Template.tests.onCreated -> 
        @autorun -> Meteor.subscribe('tests')
    
    Template.tests.helpers
        tests: -> Docs.find { type: 'test'}
    
    Template.tests.events
        'click #add_test': ->
            id = Docs.insert type: 'test'
            FlowRouter.go "/edit/#{id}"
    
    
if Meteor.isServer
    Meteor.publish 'tests', (view_mode)->
        
        me = Meteor.users.findOne @userId
        self = @
        match = {}
        if view_mode is 'mine'
            # if not me.courses
            #     Meteor.users.update @userId,
            #         $set: courses: []
            # else
            match._id = $in: me.tests
        if not @userId or not Roles.userIsInRole(@userId, ['admin'])
            match.published = true
                
        match.type = 'test'        
                
        Docs.find match
    
    
    publishComposite 'test_questions', (test_id)->
        {
            find: -> Docs.find test_id
            children: [
                { find: (test) ->
                    Docs.find
                        type: 'test_question'
                        test_id: test._id
                # children: [
                #     {
                #         find: (test) ->
                #             Docs.find
                #                 type: 'question'
                #                 test_id: test._id
                #     }
                # ]    
                }
            ]
        }            
