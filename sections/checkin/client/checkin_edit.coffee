FlowRouter.route '/checkin/edit/:doc_id',
    action: (params) ->
        BlazeLayout.render 'layout',
            # top: 'nav'
            main: 'checkin_edit'




Template.checkin_edit.onCreated ->
    # console.log FlowRouter.getParam 'doc_id'
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


Template.checkin_edit.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')


Template.checkin_edit.events
    'click #save_doc': ->
        FlowRouter.go "/checkin/view/#{@_id}"
        # selected_tags.clear()
        # selected_tags.push tag for tag in @tags

    'click #delete_doc': ->
        if confirm 'Delete this doc?'
            Docs.remove @_id
            FlowRouter.go '/'
