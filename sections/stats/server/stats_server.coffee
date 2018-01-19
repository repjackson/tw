Meteor.methods
    'calculate_user_journal_stats': (user_id)->
        total_journal_count = Docs.find(
            type: 'journal'
            author_id: user_id
            ).count()
        # console.log total_journal_count
        Meteor.users.update user_id,
            $set: "stats.journal.total": total_journal_count
            
        private_journal_count = Docs.find(
            type: 'journal'
            author_id: user_id
            published: -1
            ).count()
        # console.log total_journal_count
        Meteor.users.update user_id,
            $set: "stats.journal.private": private_journal_count
            
            
        published_journal_count = Docs.find(
            type: 'journal'
            author_id: user_id
            published: $in: [1,0]
            ).count()
        # console.log total_journal_count
        Meteor.users.update user_id,
            $set: "stats.journal.published": published_journal_count
            
            
            
            
            
            
            
    'calculate_user_check_in_stats': (user_id)->
        total_check_in_count = Docs.find(
            type: 'checkin'
            author_id: user_id
            ).count()
        # console.log total_check_in_count
        Meteor.users.update user_id,
            $set: "stats.check_in.total": total_check_in_count
            
        private_check_in_count = Docs.find(
            type: 'checkin'
            author_id: user_id
            published: -1
            ).count()
        # console.log total_check_in_count
        Meteor.users.update user_id,
            $set: "stats.check_in.private": private_check_in_count
            
            
        published_check_in_count = Docs.find(
            type: 'checkin'
            author_id: user_id
            published: $in: [1,0]
            ).count()
        # console.log total_check_in_count
        Meteor.users.update user_id,
            $set: "stats.check_in.published": published_check_in_count
            
            
            