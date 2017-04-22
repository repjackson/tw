if Meteor.isServer    
    publishComposite 'module', (module_id)->
        {
            find: ->
                Docs.find module_id
            children: [
                { 
                    find: (module) ->
                        Docs.find
                            type: 'section'
                            module_id: module_id
                    children: [
                        {
                            find: (section) ->
                                Docs.find
                                    section_id: section._id
                                    type: 'question'
                            children: [
                                {
                                    find: (question) ->
                                        Docs.find 
                                            question_id: question._id
                                            type: 'answer'
                                    }
                                ]
                            }
                        
                        ]
                }
                {
                    find: (module) ->
                        Docs.find
                            type: 'course'
                            _id: module.course_id
                }
            ]
        }