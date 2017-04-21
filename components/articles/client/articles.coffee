FlowRouter.route '/articles', action: ->
    BlazeLayout.render 'layout', 
        sub_nav: 'member_nav'
        main: 'articles'

FlowRouter.route '/article/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_article'

FlowRouter.route '/article/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'member_nav'
        main: 'article_page'

Session.setDefault 'layout_view', 'list'

Template.articles.onCreated ->
    @autorun -> Meteor.subscribe('docs', selected_tags.array(), 'article')


Template.articles.helpers
    articles: -> 
        Docs.find { type: 'article'},
            sort:
                publish_date: -1
            limit: 5
            
    is_grid_view: -> Session.equals 'layout_view', 'grid'        
    is_list_view: -> Session.equals 'layout_view', 'list'        
            
    list_layout_button_class: -> if Session.get('layout_view') is 'list' then 'teal' else 'basic'
    grid_layout_button_class: -> if Session.get('layout_view') is 'grid' then 'teal' else 'basic'
            
Template.articles.events
    'click #make_list_layout': -> Session.set 'layout_view', 'list'
    'click #make_grid_layout': -> Session.set 'layout_view', 'grid'

    'click #add_article': ->
        id = Docs.insert
            type: 'article'
        FlowRouter.go "/article/edit/#{id}"


    
Template.article_item.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'

    can_edit: -> @author_id is Meteor.userId()

    


Template.article_item.events
    'click .article_tag': ->
        if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()

    'click .edit_article': ->
        FlowRouter.go "/article/edit/#{@_id}"
