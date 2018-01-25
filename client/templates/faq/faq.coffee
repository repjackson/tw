# Template.view_faq.onCreated ->
#     @autorun -> Meteor.subscribe('facet', selected_theme_tags.array(), 'question')


Template.view_faq.helpers
    questions: -> Docs.find {type: 'question'}
     
     
Template.view_faq.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
     
            
Template.view_faq.events
    'click #add_question': ->
        id = Docs.insert
            type: 'question'
            parent_id: @_id
        FlowRouter.go "/edit/#{id}"
        
        

Template.question_item.events
    'click #delete': ->
        swal {
            title: 'Delete Question?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            doc = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove doc._id, ->
                FlowRouter.go "/faq"        
                
                
                
Template.edit_question.events
    'click #delete': ->
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            bike = Docs.findOne FlowRouter.getParam('bikes_id')
            Docs.remove bike._id, ->
                FlowRouter.go "/faq"        
