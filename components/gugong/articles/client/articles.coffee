FlowRouter.route '/articles', action: ->
    BlazeLayout.render 'layout', 
        sub_nav: 'gugong_nav'
        main: 'articles'

FlowRouter.route '/article/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_article'

FlowRouter.route '/article/view/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        sub_nav: 'gugong_nav'
        main: 'article_page'




Template.articles.onCreated ->
    @autorun -> Meteor.subscribe('docs', selected_tags.array(), 'article')

Template.articles.onRendered ->
    $('#blog_slider').layerSlider
        autoStart: true


Template.articles.helpers
    articles: -> 
        Docs.find {
            type: 'article'
            },
            sort:
                publish_date: -1
            limit: 5
            
Template.articles.events
    'click #add_article': ->
        id = Docs.insert
            type: 'article'
        FlowRouter.go "/article/edit/#{id}"





    
Template.article_item.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'primary' else 'basic'

    can_edit: -> @author_id is Meteor.userId()

    


Template.article_item.events
    'click .article_tag': ->
        if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()

    'click .edit_article': ->
        FlowRouter.go "/article/edit/#{@_id}"
