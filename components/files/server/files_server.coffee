Meteor.publish 'module_files', (module_id)->
    Files.find
        parent_module_id: module_id

    
    
Files.allow
    insert: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
    update: (userId, doc) -> Roles.userIsInRole(userId, 'admin') or userId
    remove: (userId, doc) -> 
        Roles.userIsInRole(userId, 'admin')
        # need prevention of deletion if remaing moduels language