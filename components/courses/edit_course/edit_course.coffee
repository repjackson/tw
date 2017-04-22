FlowRouter.route '/course/:course_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_course'

if Meteor.isClient
    Template.edit_course.onCreated ->
        @autorun -> Meteor.subscribe 'course', FlowRouter.getParam('course_id')
    
    
    Template.edit_course.helpers
        course: -> Docs.findOne FlowRouter.getParam('course_id')
        modules: -> Docs.find() 
        
        course_description_context: ->
            @current_doc = Docs.findOne FlowRouter.getParam('course_id')
            self = @
            {
                _value: self.current_doc.description
                _keepMarkers: true
                _className: 'froala-reactive-meteorized-override'
                toolbarInline: false
                initOnClick: false
                imageInsertButtons: ['imageByURL']
                tabSpaces: false
                height: 300
            }
        
            
    Template.edit_course.events
        'blur .froala-container': (e,t)->
            html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
            
            course_id = FlowRouter.getParam('course_id')
    
            Docs.update course_id,
                $set: description: html
                    
        'click #save_course': ->
            FlowRouter.go "/course/#{@_id}"        
                    
        'click #delete': ->
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
                course = Docs.findOne FlowRouter.getParam('course_id')
                Docs.remove course._id, ->
                    FlowRouter.go "/courses"