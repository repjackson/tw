if Meteor.isClient
    Template.view_course.onCreated ->
        @autorun => Meteor.subscribe 'child_docs', @data._id
    
    Template.view_course.onRendered ->
        Meteor.setTimeout =>
            $('.menu .item').tab()
        , 1000
    
    Template.edit_course.onRendered ->
        Meteor.setTimeout =>
            $('.menu .item').tab()
        , 1000
    
                
    Template.view_courses.events
        'click #add_course': ->
            id = Docs.insert
                type: 'course'
            FlowRouter.go "/edit/#{id}"
            
            
    
    
    Template.view_course.helpers
        background_style: -> "background-image:url('https://res.cloudinary.com/facet/image/upload/c_fit,w_500/rczjotzxkirmg4g83axa')"
        
        sales: ->
            course=Docs.findOne FlowRouter.getParam('doc_id')
            sales = Docs.findOne {parent_id:course._id, type:'course_sales'}
        
        welcome_doc: ->
            course=Docs.findOne FlowRouter.getParam('doc_id')
            Docs.findOne {_id:'WpdcfCz5GHs6qQD9R'}
        
        
    # Template.course_module_overview.onCreated ->
    #     @autorun -> Meteor.subscribe 'course_modules', FlowRouter.getParam('doc_id')
        
    # Template.course_module_overview.helpers
    #     modules: ->
    #         course = Docs.findOne FlowRouter.getParam('doc_id')
    #         modules_doc = Docs.findOne {type:'modules', parent_id:course._id}
    #         Docs.find { 
    #             parent_id: modules_doc._id },
    #             sort: number: 1

        
        
        
    Template.edit_course.onCreated ->
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    
    Template.edit_course.helpers
        course: -> Docs.findOne FlowRouter.getParam('doc_id')
        
        
    Template.edit_course.events
        'click #delete_course': ->
            swal {
                title: 'Delete Course?'
                # text: 'Confirm delete?'
                type: 'error'
                animation: false
                showCancelButton: true
                closeOnConfirm: true
                cancelButtonText: 'Cancel'
                confirmButtonText: 'Delete'
                confirmButtonColor: '#da5347'
            }, ->
                course = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.remove course._id, ->
                    FlowRouter.go "/courses"        
                    
                    
                    
# if Meteor.isServer
#     Meteor.publish 'course_modules', (course_id)->
#         course = Docs.findOne course_id
#         modules_doc = Docs.findOne {type:'modules', parent_id:course._id}
#         if modules_doc
#             Docs.find
#                 # site: Meteor.settings.public.site
#                 parent_id: modules_doc._id
            
            
            
            