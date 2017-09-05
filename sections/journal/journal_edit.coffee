if Meteor.isClient
    
    FlowRouter.route '/journal/edit/:doc_id',
        action: (params) ->
            BlazeLayout.render 'layout',
                # top: 'nav'
                main: 'journal_edit'
    
    
    
    
    Template.journal_edit.onCreated ->
        # console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


    Template.journal_edit.helpers
        doc: -> Docs.findOne FlowRouter.getParam('doc_id')

    
    Template.journal_edit.events
        'click #call_watson': ->
            parameters = 
                'text': @content
                'features':
                    'entities':
                        'emotion': true
                        'sentiment': true
                        'limit': 2
                    'keywords':
                        'emotion': true
                        'sentiment': true
                        'limit': 2
            Meteor.call 'call_watson', parameters, @_id
    
    
        'click #save_doc': ->
            FlowRouter.go "/journal/view/#{@_id}"
            # selected_tags.clear()
            # selected_tags.push tag for tag in @tags
    
        'click #delete_doc': ->
            if confirm 'Delete this doc?'
                Docs.remove @_id
                FlowRouter.go '/journal'
