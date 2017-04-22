if Meteor.isClient
    FlowRouter.route '/tests', action: ->
        BlazeLayout.render 'layout',
            sub_nav: 'member_nav'
            # sub_sub_nav: 'inspire_u_nav'
            main: 'tests'
    
    FlowRouter.route '/test/:doc_id/edit', 
        name: 'edit_test'
        action: (params) ->
            BlazeLayout.render 'layout',
                main: 'edit_test'
    
    FlowRouter.route '/test/:doc_id/view', 
        name: 'view_test'
        action: (params) ->
            BlazeLayout.render 'layout',
                sub_nav: 'member_nav'
                main: 'test_page'
    
    
    Template.tests.onCreated -> @autorun -> Meteor.subscribe('docs', selected_tags.array(), 'test')
    
    Template.tests.helpers
        tests: -> Docs.find { type: 'test'}
    
        is_grid_view: -> Session.equals 'layout_view', 'grid'        
        is_list_view: -> Session.equals 'layout_view', 'list'        
                
        list_layout_button_class: -> if Session.get('layout_view') is 'list' then 'teal' else 'basic'
        grid_layout_button_class: -> if Session.get('layout_view') is 'grid' then 'teal' else 'basic'
                
    Template.tests.events
        'click #make_list_layout': -> Session.set 'layout_view', 'list'
        'click #make_grid_layout': -> Session.set 'layout_view', 'grid'
    
        'click #add_test': ->
            id = Docs.insert type: 'test'
            FlowRouter.go "/test/#{id}/edit"
    
    
        
    Template.test_item.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
    
        can_edit: -> @author_id is Meteor.userId()
    
        
    Template.test_item.events
        'click .test_tag': -> if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()
    
        'click .edit_test': -> FlowRouter.go "/test/edit/#{@_id}"




if Meteor.isServer
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
