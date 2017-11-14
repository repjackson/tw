if Meteor.isClient
    Template.view_page.onCreated ->
        @autorun => Meteor.subscribe 'page_by_name', @data.name
    
    
    
    Template.view_page.helpers
        page: -> 
            Pages.findOne
                name: Template.currentData().name
    
    
    Template.view_page.events
        'click #edit_page': ->
            id = Pages.findOne()._id
            FlowRouter.go "/page/edit/#{id}"


if Meteor.isServer
    Meteor.publish 'page_by_name', (page)->
        Pages.find
            name: page