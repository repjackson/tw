if Meteor.isClient
    FlowRouter.route '/admin', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'admin'
     
    FlowRouter.route '/admin/settings', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'site_settings'
     
    FlowRouter.route '/admin/contact_submissions', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'contact_submissions'
 
    Template.contact_submissions.onCreated ->
        @autorun -> Meteor.subscribe 'docs', 'contact_submission'
        
    Template.contact_submissions.helpers
        submissions: ->
            Docs.find
                type: 'contact_submission'
    
    FlowRouter.route '/admin/components', action: (params) ->
        BlazeLayout.render 'layout',
            sub_nav: 'admin_nav'
            main: 'site_components'
 
    
    Template.site_components.onCreated ->
        @autorun -> Meteor.subscribe 'components'
        @autorun -> Meteor.subscribe 'site_doc'
        
    Template.site_components.helpers
        selected_components: ->
            site_doc = Docs.findOne type:'site_doc'
            if site_doc
                Docs.find
                    _id: $in: site_doc.components
                    type: 'component'
                
                
        unselected_components: ->
            site_doc = Docs.findOne type:'site_doc'
            if site_doc
                Docs.find
                    _id: $nin: site_doc.components
                    type: 'component'
                
    
    Template.site_components.events
        'click .select_component': ->
            site_doc = Docs.findOne type:'site_doc'
            Docs.update site_doc._id,
                $addToSet: components: @_id
    
        'click .unselect_component': ->
            site_doc = Docs.findOne type:'site_doc'
            Docs.update site_doc._id,
                $pull: components: @_id
    
    
    Template.site_settings.onCreated ->
        @autorun -> Meteor.subscribe 'site_doc'
    
    Template.site_settings.helpers
        site_doc: ->
            Docs.findOne
                type: 'site_doc'
            
    Template.site_settings.events
        'click #create_site_doc': ->
            Docs.insert
                type: 'site_doc'
                # site: Meteor.settings.public.site.slug
            
if Meteor.isServer
    Meteor.publish 'site_doc', ->
        Docs.find
            type: 'site_doc'
            # site: Meteor.settings.public.site.slug
            
    Meteor.publish 'components', ->
        Docs.find
            type: 'component'
            
            
            