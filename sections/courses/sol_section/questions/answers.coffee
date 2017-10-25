if Meteor.isClient
    Template.answers.helpers
        question_segment_class: ->
            found_answer = Docs.findOne
                # tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()
            if found_answer then 'raised green' else ''
                
    
        has_answered_question: ->
            # console.log @_id
            found_answer = Docs.findOne
                # tags: $in: ['answer']
                parent_id: @_id
                author_id: Meteor.userId()
            # if @number is 3
            #     if found_answer
            #         console.log "has answered question #{@number}"
            #         console.log found_answer
            #     else
            #         console.log "has NOT answered question #{@number}"
            return found_answer

        all_answers: ->
            Docs.find
                parent_id: @_id
                # tags: $in: ["answer"]
                published: 1
                
        all_private_answers: ->        
            Docs.find
                parent_id: @_id
                # tags: $in: ["answer"]
                published: -1
                
                
        my_answer: ->
            Docs.findOne
                parent_id: @_id
                # tags: $in: ["answer"]
                author_id: Meteor.userId()
                
        is_editing_my_answer: ->
            my_answer =             
                Docs.findOne
                    parent_id: @_id
                    # tags: $in: ["answer"]
                    author_id: Meteor.userId()
            Session.equals 'editing_id', my_answer._id

    Template.answers.events
        'blur #body': (e,t)->
            body = $(e.currentTarget).closest('#body').val()
            Docs.update @_id,
                $set: body: body
            
            
            
    Template.answer.onCreated ->
        @autorun => Meteor.subscribe 'doc', @data._id

            
    Template.answer.events
        'click .reply': (e,t)->
            console.log @
            new_comment_id = Docs.insert
                type: 'comment'
                parent_id: @_id
            Session.set 'editing_id', new_comment_id
            
    Template.answer.helpers
        children: ->
            Docs.find
                type: 'comment'
                parent_id: @_id
            
            
            
    Template.answers.onRendered ->
        Meteor.setTimeout ->
            $('.ui.accordion').accordion()
        , 1000
                # console.log 'subs ready'
