Meteor.publish 'module_lightwork', (module_number) ->
    Sections.find
        lightwork: true
        module_number: module_number
            
            
publishComposite 'module_downloads', (course_slug, module_number)->
    {
        find: ->
            module = 
                Modules.findOne
                    parent_course_slug: course_slug
                    number: module_number
            Files.find 
                parent_module_id: module._id
        # children: [
        #     { find: (question) ->
        #         Answers.find
        #             question_id: question._id
        #     }
        # ]
    }    


Meteor.publish 'course_modules', (course_slug)->
    Modules.find()

Meteor.publish 'module', (module_id)->
    Modules.find module_id

Meteor.publish 'module_by_course_slug', (course_slug, module_number)->
    Modules.find 
        parent_course_slug: course_slug
        number: module_number




# publishComposite 'module', (course_id, module_number)->
#     {
#         find: ->
#             Modules.find 
#                 course_id: course_id
#                 number: module_number
#         # children: [
#         #     { 
#         #         find: (module) ->
#         #             Docs.find
#         #                 type: 'section'
#         #                 course: course
#         #                 module_number: module_number
#                 # children: [
#                 #     {
#                 #         find: (section) ->
#                 #             Docs.find
#                 #                 section_id: section._id
#                 #                 type: 'question'
#                 #         children: [
#                 #             {
#                 #                 find: (question) ->
#                 #                     Docs.find 
#                 #                         question_id: question._id
#                 #                         type: 'answer'
#                 #                 }
#                 #             ]
#                 #         }
                    
#                 #     ]
#             # }
#             {
#                 find: (module) ->
#                     Courses.find
#                         slug: module.course
#             }
#         # ]
#     }
    
    
Modules.allow
    insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
    update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
    remove: (userId, doc) -> 
        Roles.userIsInRole(userId, 'admin')
        # need prevention of deletion if remaing moduels language