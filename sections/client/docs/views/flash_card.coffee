Template.youtube.onRendered ->
    Meteor.setTimeout (->
        $('.shape').shape();
    ), 2000




Template.flash_card.events
    'blur .front': (e)->
        front = $(e.currentTarget).closest('.front').val()
        Docs.update @_id,
            $set: front: front

    
    'blur .back': (e)->
        back = $(e.currentTarget).closest('.back').val()
        Docs.update @_id,
            $set: back: back
    
    'click .flip': (e,t)->
        $('.shape').shape('flip over')
        # $(e.currentTarget).closest('.shape')
        # .val()

