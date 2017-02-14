@Questions = new Meteor.Collection 'questions'


FlowRouter.route '/questions', action: (params) ->
    BlazeLayout.render 'layout',
        # cloud: 'cloud'
        main: 'questions'

if Meteor.isClient
    Template.questions.onCreated -> 
        @autorun -> Meteor.subscribe('questions', FlowRouter.getParam('module_id'))

    Template.questions.helpers
        questions: -> 
            Questions.find { }
    

    

    Template.view.events
    
        'click .edit': -> FlowRouter.go("/edit_question/#{@_id}")

    Template.questions.events
        'click #add_question': ->
            question = $('#new_question').val()
            # console.log question
            id = Questions.insert
                module: FlowRouter.getParam('module_id')
                text: question
    


if Meteor.isServer
    Questions.allow
        insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        update: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> Roles.userIsInRole(userId, 'admin')
    
    
    
    
    Meteor.publish 'questions', ()->
    
        self = @
        match = {}
        # selected_tags.push current_herd
        # match.tags = $all: selected_tags
        # if selected_tags.length > 0 then match.tags = $all: selected_tags

        

        Questions.find match
    
    Meteor.publish 'question', (id)->
        Questions.find id
    
