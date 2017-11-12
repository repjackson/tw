@Tags = new Meteor.Collection 'tags'
@Docs = new Meteor.Collection 'docs'

Docs.before.insert (userId, doc)=>
    timestamp = Date.now()
    doc.timestamp = timestamp
    # console.log moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
    # date = moment(timestamp).format('Do')
    # weekdaynum = moment(timestamp).isoWeekday()
    # weekday = moment().isoWeekday(weekdaynum).format('dddd')


    # month = moment(timestamp).format('MMMM')
    # year = moment(timestamp).format('YYYY')

    # date_array = [weekday, month, date, year]
    # if _
    #     date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
    # # date_array = _.each(date_array, (el)-> console.log(typeof el))
    # # console.log date_array
    #     doc.timestamp_tags = date_array

    doc.author_id = Meteor.userId()
    # doc.tag_count = doc.tags?.length
    # doc.points = 0
    # doc.components = {}
    # doc.read_by = [Meteor.userId()]
    # doc.upvoters = []
    # doc.downvoters = []
    # doc.published = 0
    return

# Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
#     # if doc.tags
#     # doc.tag_count = doc.tags.length
#     # console.log 'doc tags length',doc.tags.length
#     # console.log 'modifier', modifier
#     # doc.child_count = Meteor.call('calculate_child_count', doc._id)
#     Meteor.call 'calculate_tag_count', doc._id, ->
# ), fetchPrevious: true


# Docs.before.update (userId, doc, fieldNames, modifier, options) ->
# #   modifier.$set = modifier.$set or {}
#     console.log doc.tags.length
#     console.log 'modifier', modifier
#     # modifier.$set.tag_count = doc.tags.length
#     return


# Docs.after.insert (userId, doc)->
#     if doc.parent_id
#         Meteor.call 'calculate_child_count', doc.parent_id
    
    
# Docs.after.remove (userId, doc)->
#     if doc.parent_id
#         Meteor.call 'calculate_child_count', doc.parent_id



Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    # parent: -> Docs.findOne @parent_id
    # has_children: -> if Docs.findOne(parent_id: @_id) then true else false


Meteor.methods
    add: (tags=[])->
        id = Docs.insert {}
        return id

    # calculate_tag_count: (doc_id)->
    #     doc = Docs.findOne doc_id
    #     tag_count = doc.tags.length
    #     Docs.update doc_id, 
    #         $set: tag_count: tag_count
        



# FlowRouter.route '/',
#   triggersEnter: [ (context, redirect) ->
#     redirect '/view/puBqCqAFMxGJTcgav'
#     return
#  ]

FlowRouter.route '/', 
    name: 'view'
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'home'



FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'
