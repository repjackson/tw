if Meteor.isClient
    Template.my_courses.onCreated -> 
        @autorun -> Meteor.subscribe('my_courses')


    Template.my_courses.helpers
        my_courses: -> 
            if Meteor.user()?.courses
                Docs.find
                    type: 'course'
                    _id: $in: Meteor.user().courses
    
        in_course: ->
            Meteor.user()?.my_courses and @title in Meteor.user().my_courses
    
if Meteor.isServer
    Meteor.publish 'my_courses', ->
        me = Meteor.users.findOne @userId
        if me.courses
            Docs.find
                type: 'course'
                _id: $in: me.courses