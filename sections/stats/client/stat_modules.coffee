Template.leaderboard.onCreated ->
    @autorun -> Meteor.subscribe('people', selected_people_tags.array())

Template.leaderboard.helpers
    players: ->
        Meteor.users.find {},
            sort: points: -1
            
Template.journal_stats.onCreated ->
    @autorun -> Meteor.subscribe('people', selected_people_tags.array())

Template.journal_stats.helpers
    journal_authors: ->
        Meteor.users.find {},
            sort: points: -1
            
            
Template.journal_stat.onCreated ->
    # Meteor.subscribe 'usernames'
Template.journal_stat.helpers
    journal_authors: ->
        Meteor.users.find {},
            sort: points: -1
            
    journal_published_count: -> Counts.get('journal_published_count')
            
