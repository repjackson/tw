
FlowRouter.route '/admin', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        sub_nav: 'admin_nav'
        main: 'users'
 
 
if Meteor.isClient
    Template.user_table.onCreated ->
        self = @
        self.autorun ->
            self.subscribe 'hub_users'
    
    
    Template.user_table.helpers
        hub_users: -> 
            Meteor.users.find {}
            
        user_is_admin: -> 
            # console.log @
            Roles.userIsInRole(@_id, 'admin')
    
        user_is_member: -> 
            # console.log @
            Roles.userIsInRole(@_id, 'member')
    
    
    
    
    
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
    
    
        'click .check_in': ->
            Meteor.users.update @_id,
                $set: checked_in: true
    
        'click .check_out': ->
            Meteor.users.update @_id,
                $set: checked_in: false
    
    
    
 
 
        
if Meteor.isServer
    Meteor.publish 'hub_users', ->
        match = {}
    
        Meteor.users.find match,
            fields:
                tags: 1
                name: 1
                roles: 1
                emails: 1
                profile: 1
                image_id: 1
                checked_in: 1