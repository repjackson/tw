if Meteor.isClient
    Template.journal_responses.onCreated ->
        console.log FlowRouter.getParam 'doc_id'
        @autorun -> Meteor.subscribe('journal_responses', FlowRouter.getParam('doc_id'))


    Template.journal_responses.helpers
        public_responses: -> Docs.find parent_id: FlowRouter.getParam('doc_id')

        my_response: -> 
            Docs.findOne 
                parent_id: FlowRouter.getParam('doc_id')
                author_id: Meteor.userId()
                
                
    Template.journal_responses.events
        'click #write_response': ->
            # console.log 'hi'
            Docs.insert
                parent_id: FlowRouter.getParam('doc_id')  


if Meteor.isServer
    Meteor.publish 'journal_responses', (parent_doc_id)->
        Docs.find
            parent_id: parent_doc_id