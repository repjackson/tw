
    
Meteor.publish 'sol_members', (selected_course_member_tags) ->
    match = {}
    if selected_course_member_tags.length > 0 then match.tags = $all: selected_course_member_tags
    match._id = $ne: @userId
    # match["profile.published"] = true
    match.roles = $in: ['sol','sol_demo']
    
    Meteor.users.find match

    
    
    # Meteor.users.find
    #     # roles: $in: ['sol_member', 'sol_demo_member']
        
        
Meteor.publish 'course_member_tags', (selected_course_member_tags)->
    self = @
    match = {}
    if selected_course_member_tags.length > 0 then match.tags = $all: selected_course_member_tags
    match._id = $ne: @userId
    # match["profile.published"] = true
    match.roles = $in: ['sol','sol_demo']

    # console.log match

    people_cloud = Meteor.users.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_course_member_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log 'cloud, ', people_cloud
    people_cloud.forEach (tag, i) ->
        self.added 'people_tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()



Meteor.publish 'sol_course', ->
    Docs.find
        tags: ['course','sol']


Meteor.publish 'sol_signers', ->
    course = Docs.findOne tags: ['course', 'sol']
    user_id_list =  _.pluck(course.agreements, 'user_id' )
    Meteor.users.find
        _id: $in: user_id_list
        
        
        
Meteor.publish 'sol_progress', ()->
    Docs.find
        tags: $all: ['sol', "course progress"]
        author_id: @userId
        


Meteor.methods
    'calculate_sol_progress': ()->
        sol_progress_doc = 
            Docs.findOne
                tags: $all: ['sol', 'course progress']
                author_id: Meteor.userId()
        if not sol_progress_doc
            console.log 'didnt find progress doc, creating'
            Docs.insert
                tags: ['sol', 'course progress']
                author_id: Meteor.userId()

            sol_progress_doc = 
                Docs.findOne
                    tags: $all: ['sol', 'course progress']
                    author_id: Meteor.userId()
            console.log 'new progress doc:', sol_progress_doc


        sol_progress_percent = 0
        module_complete_count = 0
        current_module = 0

        sol_module_count = 
            Docs.find( 
                tags: $all: ['sol', 'module']
            ).count()
        
        for number in [1..sol_module_count]
            module_progress_doc = 
                Docs.findOne
                    tags: ['sol', "module #{number}", 'module progress']
                    author_id: Meteor.userId()
            if module_progress_doc
                # console.log typeof module_progress_doc.module_progress_percent
                if module_progress_doc.module_progress_percent > 0
                    if Math.round(module_progress_doc.module_progress_percent) is 100 then module_complete_count += 1
                    else current_module = number
                    sol_progress_percent += 100/sol_module_count*module_progress_doc.module_progress_percent/100
        # console.log 'sol progress', sol_progress_percent
        # console.log 'module_complete_count', module_complete_count
        # console.log 'current_module', current_module
        
        if sol_module_count is module_complete_count
            sol_modules_complete = true
        else
            sol_modules_complete = false
        
        
        
        # welcome calculation
        
        welcome_count = 0
        if sol_progress_doc.watched_inspiration_video then welcome_count++
        if sol_progress_doc.watched_welcome_video then welcome_count++
        if sol_progress_doc.has_agreed then welcome_count++
        
        if welcome_count is 3 then welcome_complete = true else welcome_complete = false
        
        
        Docs.update sol_progress_doc._id,
            $set:
                sol_progress_percent: sol_progress_percent
                current_module: current_module
                module_complete_count: module_complete_count
                sol_module_count: sol_module_count
                sol_modules_complete: sol_modules_complete
                welcome_complete: welcome_complete
                welcome_count: welcome_count
        return sol_progress_percent
