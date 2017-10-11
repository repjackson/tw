Template.leaderboard.onCreated ->
    Meteor.subscribe 'usernames'

Template.leaderboard.helpers
    players: ->
        Meteor.users.find {},
            sort: points: -1
            
Template.journal_stats.onCreated ->
    Meteor.subscribe 'usernames'

Template.journal_stats.helpers
    journal_stats: ->
        Meteor.users.find {},
            sort: points: -1
            
            
Template.journal_stat.onCreated ->
    Meteor.subscribe 'usernames'
Template.journal_stat.helpers
    journal_stats: ->
        Meteor.users.find {},
            sort: points: -1
            
    journal_published_count: -> Counts.get('journal_published_count')
            
