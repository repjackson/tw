FlowRouter.route '/edit_herd/:herd_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_herd'




if Meteor.isClient
    Template.edit_herd.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'herd', FlowRouter.getParam('herd_id')
    
    
    Template.edit_herd.helpers
        herd: ->
            Herds.findOne FlowRouter.getParam('herd_id')
        
            
    Template.edit_herd.events
        'click #save': ->
            FlowRouter.go "/view_herd/#{@_id}"


        'keydown #add_tag': (e,t)->
            if e.which is 13
                herd_id = FlowRouter.getParam('herd_id')
                tag = $('#add_tag').val().toLowerCase().trim()
                if tag.length > 0
                    Herds.update herd_id,
                        $addToSet: tags: tag
                    $('#add_tag').val('')
    
        'click .doc_tag': (e,t)->
            organization = Herds.findOne FlowRouter.getParam('herd_id')
            tag = @valueOf()
            Herds.update FlowRouter.getParam('herd_id'),
                $pull: tags: tag
            $('#add_tag').val(tag)

        'blur #name': ->
            name = $('#name').val()
            Herds.update FlowRouter.getParam('herd_id'),
                $set: name: name
        
        'blur #description': ->
            description = $('#description').val()
            Herds.update FlowRouter.getParam('herd_id'),
                $set: description: description
        
        
        'blur #herd_tag': ->
            herd_tag = $('#herd_tag').val()
            Herds.update FlowRouter.getParam('herd_id'),
                $set: herd_tag: herd_tag
                
        
