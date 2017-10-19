Template.leaderboard.onCreated ->
    @autorun -> Meteor.subscribe('people', selected_people_tags.array())

Template.leaderboard.helpers
    players: ->
        Meteor.users.find { points: $gt: 0 },
            sort: points: -1
            
            
            
Template.journal_stats.onCreated ->
    # @autorun -> Meteor.subscribe('people', selected_people_tags.array())

Template.journal_stats.helpers
    journal_authors: ->
        Meteor.users.find { "stats.journal.total": $gt: 0 },
            sort: "stats.journal.total": -1
            
            
Template.journal_stat.onCreated ->
    # Meteor.subscribe 'usernames'
Template.journal_stat.helpers
            
Template.journal_stat.events
    'click .calculate_user_journal_stats': ->
        Meteor.call 'calculate_user_journal_stats', @_id
        




Template.check_in_stats.onCreated ->
    # @autorun -> Meteor.subscribe('people', selected_people_tags.array())

Template.check_in_stats.helpers
    check_in_authors: ->
        Meteor.users.find { "stats.check_in.total": $gt: 0},
            sort: "stats.check_in.total": -1
            
            
Template.check_in_stat.onCreated ->
    # Meteor.subscribe 'usernames'
Template.check_in_stat.helpers
            
Template.check_in_stat.events
    'click .calculate_user_check_in_stats': ->
        Meteor.call 'calculate_user_check_in_stats', @_id
        
        
        
        
Template.read_stats.onCreated ->
    # @autorun -> Meteor.subscribe('people', selected_people_tags.array())

Template.read_stats.helpers
    readers: ->
        Meteor.users.find { "stats.read": $gt: 0},
            sort: "stats.read": -1
            
            
Template.read_stat.onCreated ->
    # Meteor.subscribe 'usernames'
Template.read_stat.helpers
            
Template.read_stat.events
    'click .calculate_user_read_stats': ->
        Meteor.call 'calculate_user_read_stats', @_id
        
        
        