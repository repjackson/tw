Template.slider.onRendered ->
    Meteor.setTimeout (->
        $('#layerslider').layerSlider
            autoStart: true
            # firstLayer: 1
            # skin: 'borderlesslight'
            # skinsPath: '/static/layerslider/skins/'
        ), 1000



FlowRouter.route '/slides', action: ->
    BlazeLayout.render 'layout', 
        main: 'slides'

Template.slides.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'slide')

Template.slider.onCreated ->
    @autorun -> Meteor.subscribe('slides')

Template.slider.helpers
    slides: ->
        Docs.find
            type: 'slide'

Template.slides.helpers
    slides: -> Docs.find {type: 'slide'}
     
     
Template.slides.events
    'click #add_slide': ->
        id = Docs.insert
            type: 'slide'
        FlowRouter.go "/slide/#{id}"
        Session.set 'editing_id', id
        
        

Template.slide.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.slide.helpers
    slide: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.slide.events
    'click #delete': ->
        swal {
            title: 'Delete slide?'
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
                FlowRouter.go "/slides"        
                
                
                
FlowRouter.route '/slide/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'slide'

Template.slide.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.slide.helpers
    slide: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.slide.events
    'click #delete_slide': ->
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
            slide = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove slide._id, ->
                FlowRouter.go "/slides"        
