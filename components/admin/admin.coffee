if Meteor.isClient

    FlowRouter.route '/admin/members', action: (params) ->
        BlazeLayout.render 'layout',
            nav: 'nav'
            sub_nav: 'admin_nav'
            main: 'user_table'
     
    FlowRouter.route '/admin/pages', action: (params) ->
        BlazeLayout.render 'layout',
            nav: 'nav'
            sub_nav: 'admin_nav'
            main: 'pages'
 
    FlowRouter.route '/admin/lab', action: (params) ->
        BlazeLayout.render 'layout',
            nav: 'nav'
            sub_nav: 'admin_nav'
            main: 'twlab'
 
 
    Template.user_table.onCreated ->
        @autorun -> Meteor.subscribe 'members'
        @autorun -> Meteor.subscribe 'courses'
    
    
    Template.user_table.helpers
        members: -> 
            Meteor.users.find {}
            
        user_is_admin: -> 
            # console.log @
            Roles.userIsInRole(@_id, 'admin')
    
        user_is_member: -> 
            # console.log @
            Roles.userIsInRole(@_id, 'member')
    
        user_courses: ->
            if @courses
                Courses.find
                    _id: $in: @courses
    
    
    
    Template.user_table.events
        'click .remove_admin': ->
            self = @
            swal {
                title: "Remove #{@emails[0].address} from Admins?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Remove Privilages'
                closeOnConfirm: false
            }, ->
                Roles.removeUsersFromRoles self._id, 'admin'
                swal "Removed Admin Privilages from #{self.emails[0].address}", "",'success'
                return
    
    
        'click .make_admin': ->
            self = @
            swal {
                title: "Make #{@emails[0].address} an Admin?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Make Admin'
                closeOnConfirm: false
            }, ->
                Roles.addUsersToRoles self._id, 'admin'
                swal "Made #{self.emails[0].address} an Admin", "",'success'
                return
    
        'click .remove_member': ->
            self = @
            swal {
                title: "Remove #{@emails[0].address} from members?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Remove Member Status'
                closeOnConfirm: false
            }, ->
                Roles.removeUsersFromRoles self._id, 'member'
                swal "Removed member privilages from #{self.emails[0].address}", "",'success'
                return
    
    
        'click .make_member': ->
            self = @
            swal {
                title: "Make #{@emails[0].address} a member?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Make Member'
                closeOnConfirm: false
            }, ->
                Roles.addUsersToRoles self._id, 'member'
                swal "Made #{self.emails[0].address} an member", "",'success'
                return
    
    
    
 
 
        
if Meteor.isServer
    Meteor.publish 'members', ->
        match = {}
        Meteor.users.find match
         
    Accounts.onCreateUser (options, user) ->
        user
