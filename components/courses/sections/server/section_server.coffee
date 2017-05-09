publishComposite 'section', (course, parent_module_number, section_number)->
        {
            find: ->
                Sections.find 
                    parent_module_number: parent_module_number
                    parent_module_id: parent_module_id
                    section_number: section_number
            # children: [
            #     {
            #         find: (section) ->
            #             Docs.find
            #                 section_id: section._id
            #                 type: 'question'
            #         children: [
            #             {
            #                 find: (question) ->
            #                     Docs.find 
            #                         question_id: question._id
            #                         type: 'answer'
            #                 }
            #             ]
            #         }
                
            #     ]
        }


