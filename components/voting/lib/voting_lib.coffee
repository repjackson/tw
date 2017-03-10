Meteor.methods
    vote_up: (id)->
        post = Posts.findOne id
        if not post.upvoters
            Posts.update id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in post.upvoters #undo upvote
            Posts.update id,
                $pull: upvoters: Meteor.userId()
                $inc: points: -1
            Meteor.users.update post.author_id, $inc: points: -1
            # Meteor.users.update Meteor.userId(), $inc: points: 1

        else if Meteor.userId() in post.downvoters #switch downvote to upvote
            Posts.update id,
                $pull: downvoters: Meteor.userId()
                $addToSet: upvoters: Meteor.userId()
                $inc: points: 2
            Meteor.users.update post.author_id, $inc: points: 2

        else #clean upvote
            Posts.update id,
                $addToSet: upvoters: Meteor.userId()
                $inc: points: 1
            Meteor.users.update post.author_id, $inc: points: 1
            # Meteor.users.update Meteor.userId(), $inc: points: -1
        # Meteor.call 'generate_upvoted_cloud', Meteor.userId()


    vote_down: (id)->
        post = Posts.findOne id
        if not post.downvoters
            Posts.update id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in post.downvoters #undo downvote
            Posts.update id,
                $pull: downvoters: Meteor.userId()
                $inc: points: 1
            Meteor.users.update post.author_id, $inc: points: 1
            # Meteor.users.update Meteor.userId(), $inc: points: 1

        else if Meteor.userId() in post.upvoters #switch upvote to downvote
            Posts.update id,
                $pull: upvoters: Meteor.userId()
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -2
            Meteor.users.update post.author_id, $inc: points: -2

        else #clean downvote
            Posts.update id,
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -1
            Meteor.users.update post.author_id, $inc: points: -1
            # Meteor.users.update Meteor.userId(), $inc: points: -1
        Meteor.call 'generate_downvoted_cloud', Meteor.userId()
