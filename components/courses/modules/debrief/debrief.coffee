if Meteor.isClient
    FlowRouter.route '/course/:slug/module/:module_number/debrief', 
        name: 'module_debrief'
        action: (params) ->
            BlazeLayout.render 'view_module',
                module_content: 'module_debrief'
        

    Template.module_debrief.onCreated ->
        @autorun -> Meteor.subscribe 'debrief_questions', course=FlowRouter.getParam('slug'), module_number=parseInt FlowRouter.getParam('module_number')
    

    Template.module_debrief.helpers
        debrief_questions: -> 
            module_number = parseInt FlowRouter.getParam('module_number')
            
            
            Docs.find
                type: 'question'
                debrief: true
                module_number: module_number
            

                
if Meteor.isServer
    publishComposite 'debrief_questions', (module_number)->
        {
            find: ->
                Docs.find 
                    type: 'question'
                    debrief: true
                    module_number: module_number
            children: [
                { find: (question) ->
                    Docs.find
                        type: 'answer'
                        question_id: question._id
                }
            ]
        }