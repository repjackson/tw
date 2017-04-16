FlowRouter.route '/products', action: ->
    BlazeLayout.render 'layout',
        sub_nav: 'gugong_nav'
        main: 'products'

FlowRouter.route '/product/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_product'

FlowRouter.route '/product/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'gugong_nav'
        main: 'product_page'

if Meteor.isClient
    Template.products.onCreated ->
        @autorun -> Meteor.subscribe('selected_products', selected_tags.array())
    
    
    Template.products.helpers
        products: -> 
            Docs.find {
                type: 'product'
                },
                sort:
                    publish_date: -1
                limit: 5
                
    Template.products.events
        'click #add_product': ->
            id = Docs.insert
                type: 'product'
            FlowRouter.go "/product/edit/#{id}"
    
    
    
    
    
        
    Template.product_item.helpers
        tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'
    
        can_edit: -> @author_id is Meteor.userId()
    
        
    
    
    Template.product_item.events
        'click .product_tag': ->
            if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()
    
        'click .edit_product': ->
            FlowRouter.go "/product/edit/#{@_id}"



if Meteor.isServer
    Meteor.publish 'selected_products', (selected_product_tags)->
        
        self = @
        match = {}
        if selected_product_tags.length > 0 then match.tags = $all: selected_product_tags
        match.type = 'product'
        if not @userId or not Roles.userIsInRole(@userId, ['admin'])
            match.published = true
        
    
        Docs.find match,
            limit: 10
            sort: 
                publish_date: -1
    
    
    Meteor.publish 'product', (doc_id)->
        Docs.find doc_id

    
