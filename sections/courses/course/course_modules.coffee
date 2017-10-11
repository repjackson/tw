if Meteor.isClient
    FlowRouter.route '/course/:course_slug/modules', 
        name: 'course_modules'
        action: (params) ->
            BlazeLayout.render 'view_course',
                course_content: 'course_modules'
    
    Template.course_modules.onCreated ->
        # @autorun -> Meteor.subscribe 'course_modules', FlowRouter.getParam('course_slug')
        @autorun -> Meteor.subscribe 'sol_modules'
    
    Template.course_modules.onRendered ->
        Meteor.setTimeout ->
            $('.module_percent_complete_bar').progress()
        , 1000

    
    Template.course_modules.helpers
        # modules: -> Modules.find { }, sort: number: 1
        
        sol_modules: ->
            Docs.find {
                type: 'module'},
                sort: number: 1
        
        available_segment_class: ->
            module_progress_doc = Docs.findOne 
                # tags: ['sol', "module #{@number}", 'module progress']
                type: 'module_progress'
                parent_id: @_id
                author_id: Meteor.userId()
            if module_progress_doc and module_progress_doc.module_progress_percent > 99 then 'green' else ''

            
        module_is_complete: ->
            module_progress_doc = Docs.findOne 
                # tags: ['sol', "module #{@number}", 'module progress']
                type: 'module_progress'
                parent_id: @_id
                author_id: Meteor.userId()
            if module_progress_doc and module_progress_doc.module_progress_percent > 99 then true else false

            
        module_is_available: ->
            if Roles.userIsInRole(Meteor.userId(), 'sol_demo') and @number < 2
                return true
            else if Roles.userIsInRole(Meteor.userId(), ['admin']) 
                return true
            else 
                if @number is 1 then return true
                else
                    previous_module_number = @number - 1
                    previous_module_doc = 
                        Docs.findOne
                            type: 'module'
                            number: previous_module_number
                    if previous_module_doc
                        previous_module_progress_doc = 
                            Docs.findOne 
                                type: 'module_progress'
                                parent_id: previous_module_doc._id
                                author_id: Meteor.userId()
                    if previous_module_progress_doc and previous_module_progress_doc.module_progress_percent > 99 then return true else return false

                return false
    
        module_progress_doc: ->
            Docs.findOne 
                type: 'module_progress'
                parent_id: @_id
                author_id: Meteor.userId()
        
        
        user_progress: ->
            progress_doc = Docs.findOne 
                type: 'module_progress'
                parent_id: @_id
                author_id: Meteor.userId()
            if progress_doc
                 progress_doc.module_progress_percent
            else
                0
    
    Template.course_modules.events
        'click #add_sol_module': ->
            Docs.insert
                type: 'module'
            
            
if Meteor.isServer
    publishComposite 'sol_modules', ->
        {
            find: -> Docs.find type: 'module'
            children: [
                { find: (module) ->
                    Docs.find 
                        type: 'module_progress'
                        parent_id: module._id
                        author_id: Meteor.userId()
                    }
                ]    
        }
