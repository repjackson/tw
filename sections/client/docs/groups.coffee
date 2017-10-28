# Template.group_component.events
#     'click .remove_component': ->
#         doc = Docs.findOne FlowRouter.getParam('doc_id')
#         # console.log @
#         Docs.update doc._id,
#             $pull: components: @

# Template.responses.events
#     'click #add_response': ->
#         Docs.insert
#             parent_id: FlowRouter.getParam 'doc_id'
#             type: 'response'
        
# Template.response.onCreated ->
#     @editing = new ReactiveVar(false)

# Template.response.helpers
#     editing_mode: -> Template.instance().editing.get()

# Template.response.events
#     'click .edit_this': (e,t)-> t.editing.set true
#     'click .save_doc': (e,t)-> t.editing.set false

#     'keyup #tag_input': (e,t)->
#         e.preventDefault()
#         val = $('#tag_input').val().toLowerCase().trim()
#         switch e.which
#             when 13 #enter
#                 unless val.length is 0
#                     Docs.update Template.currentData()._id,
#                         $addToSet: tags: val
#                     $('#tag_input').val ''
#             # when 8
#             #     if val.length is 0
#             #         result = Docs.findOne(Template.currentData()._id).tags.slice -1
#             #         $('#theme_tag_select').val result[0]
#             #         Docs.update Template.currentData()._id,
#             #             $pop: tags: 1


#     'click .doc_tag': (e,t)->
#         tag = @valueOf()
#         Docs.update Template.currentData()._id,
#             $pull: tags: tag
#         $('#tag_input').val(tag)


# Template.responses.helpers
#     responses: ->
#         Docs.find {
#             parent_id: FlowRouter.getParam 'doc_id'
#         }, sort: number: 1

Template.leaves.helpers
    leaves: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
            # author_id: Meteor.userId()
            # type: 'child'
        }, sort: number: 1


Template.leaves.events
    'click #add_leaf': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            # type: 'child'
        
        
        
Template.twigs.helpers
    twigs: ->
        Docs.find {
            parent_id: FlowRouter.getParam 'doc_id'
            # author_id: Meteor.userId()
            # type: 'child'
        }, sort: number: 1


Template.twigs.events
    'click #add_twig': ->
        Docs.insert
            parent_id: FlowRouter.getParam 'doc_id'
            type: 'twig'
        
