Template.features.events
    'click #add_feature': ->
        id = Docs.insert type: 'feature'
        FlowRouter.go "/edit/#{id}"

