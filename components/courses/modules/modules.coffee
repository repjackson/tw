if Meteor.isServer    
    publishComposite 'module', (course, module_number)->
        {
            find: ->
                Docs.find 
                    type: 'module'
                    course: course
                    number: module_number
            children: [
                { 
                    find: (module) ->
                        Docs.find
                            type: 'section'
                            course: course
                            module_number: module_number
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
                            slug: module.course
                }
            ]
        }