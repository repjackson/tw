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
 
    Template.user_table.onCreated ->
        @autorun -> Meteor.subscribe 'members'
        @autorun -> Meteor.subscribe 'courses'
    
    
    Template.user_table.helpers
        members: -> 
            Meteor.users.find {}
            
        is_admin: -> 
            # console.log @
            Roles.userIsInRole(@_id, 'admin')
    
        is_sol_member: -> 
            # console.log @
            Roles.userIsInRole(@_id, 'sol_member')
    
        user_courses: ->
            if @courses
                Docs.find
                    type: 'course'
                    _id: $in: @courses
    
    
    
    Template.user_table.events
        'click .remove_admin': ->
            self = @
            swal {
                title: "Remove #{@username} from Admins?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Remove Privilages'
                closeOnConfirm: false
            }, ->
                Roles.removeUsersFromRoles self._id, 'admin'
                swal "Removed Admin Privilages from #{self.username}", "",'success'
                return
    
    
        'click .make_admin': ->
            self = @
            swal {
                title: "Make #{@username} an Admin?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Make Admin'
                closeOnConfirm: false
            }, ->
                Roles.addUsersToRoles self._id, 'admin'
                swal "Made #{self.username} an Admin", "",'success'
                return
    
        'click .remove_sol_member': ->
            self = @
            swal {
                title: "Remove #{@username} from SOL?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Remove Member Status'
                closeOnConfirm: false
            }, ->
                Roles.removeUsersFromRoles self._id, 'sol_member'
                swal "Removed #{self.username} from SOL", "",'success'
                return
    
    
        'click .make_sol_member': ->
            self = @
            swal {
                title: "Add #{@username} to SOL?"
                # text: 'You will not be able to recover this imaginary file!'
                type: 'warning'
                animation: false
                showCancelButton: true
                # confirmButtonColor: '#DD6B55'
                confirmButtonText: 'Add to SOL'
                closeOnConfirm: false
            }, ->
                Roles.addUsersToRoles self._id, 'sol_member'
                swal "Made #{self.username} a SOL Member", "",'success'
                return
    
    
    
 
 
        
if Meteor.isServer
    Meteor.publish 'members', ->
        match = {}
        Meteor.users.find match
         
    Accounts.onCreateUser (options, user) ->
        user
