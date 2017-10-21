if Meteor.isClient
    # FlowRouter.route '/course/sol/module/:module_number/sol_sections', 
    #     name: 'view_sol_sections'
    #     action: (params) ->
    #         BlazeLayout.render 'view_module',
    #             module_content: 'sol_sections'
    
    Template.sol_sections.onCreated ->
        # @autorun -> Meteor.subscribe 'module', parseInt FlowRouter.getParam('module_number')
        
        # @autorun -> Meteor.subscribe 'sol_sections', parseInt FlowRouter.getParam('module_number')
        # module_doc = Docs.findOne 
        #     tags: $in: ['module']
        #     number: parseInt FlowRouter.getParam('module_number')
        # console.log module_doc


    Template.sol_section.onRendered ->
        self = @
        
        @autorun =>
            Meteor.setTimeout ->
                sol_section_progress_doc =  Docs.findOne(tags: $in: ["sol_section progress"])
                # console.log sol_section_progress_doc
                $('.sol_section_percent_complete_bar').progress(
                    autoSuccess: false
                    );
            , 1000








    Template.sol_section.onCreated ->
        @editing = new ReactiveVar(false)

    Template.sol_section.helpers
        editing: -> Template.instance().editing.get()

        user_progress: ->
            # console.log @
            sol_section_progress_doc = Docs.findOne(type: 'sol_section_progress', parent_id: @_id)
            # console.log sol_section_progress_doc
            if sol_section_progress_doc
                sol_section_progress_doc.percent_complete
            else
                0
        sol_section_progress_doc: -> 
            sol_section_progress_doc = Docs.findOne(type: 'sol_section_progress', parent_id: @_id)
            # console.log sol_section_progress_doc
            sol_section_progress_doc
            
        sol_section_is_available: ->
            if Roles.userIsInRole(Meteor.userId(), 'admin') then true
            else if @number is 1 then true
            else
                previous_sol_section_number = @number - 1
                previous_sol_section_doc = Docs.findOne(type:'sol_section', number: previous_sol_section_number)
                if previous_sol_section_doc
                    previous_sol_section_progress_doc = 
                        Docs.findOne
                            type:'sol_section_progress', 
                            parent_id: previous_sol_section_doc._id

                if previous_sol_section_progress_doc and previous_sol_section_progress_doc.percent_complete is 100 then true else false

        sol_section_is_complete: ->
            sol_section_progress_doc = Docs.findOne(type: 'sol_section_progress', parent_id: @_id)
            if sol_section_progress_doc and sol_section_progress_doc.percent_complete > 99 then true else false



    Template.sol_sections.helpers
        sol_sections: ->
            Docs.find {
                type: 'sol_section' },
                sort: number: 1
                
    Template.sol_sections.events
        'click #add_sol_section': ->
            Docs.insert
                type: 'sol_section'
                parent_id: FlowRouter.getParam('doc_id')
                
    Template.sol_section.events
        'click .edit_this': (e,t)-> 
            # console.log t.editing
            t.editing.set true
        'click .save_doc': (e,t)-> 
            # console.log t.editing
            t.editing.set false
        'click .sol_section_summary': ->
            swal {
                title: "sol_section #{@number}: #{@title} Summary"
                html: true
                text: @content
                animation: true
                showCancelButton: false
                closeOnConfirm: true
                confirmButtonText: 'Back'
            }

            
            
        # 'mouseover .item': (e,t)->
        #     $(e.currentTarget).closest('.item').transition('pulse')

                
        # 'mouseover .header': (e,t)->
        #     $(e.currentTarget).closest('.header').transition('tada')

                
                
                
                
# if Meteor.isServer
#     publishComposite 'sol_sections', (module_number)->
#         {
#             find: ->
#                 Docs.find
#                     type: 'sol_section'
#                     module_number: module_number
#             children: [
#                 { find: (sol_section) ->
#                     Docs.find 
#                         tags: $all: ['sol', "module #{module_number}","sol_section progress"]
#                         author_id: @userId
#                     }
#                 ]    
#         }
            
            
