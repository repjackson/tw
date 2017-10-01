FlowRouter.route '/lightschool', action: ->
    BlazeLayout.render 'layout',
        # sub_nav: 'member_nav'
        # sub_sub_nav: 'lightschool_nav'
        main: 'lightschool'

FlowRouter.route '/lightschool/decks', action: ->
    BlazeLayout.render 'layout',
        # sub_nav: 'member_nav'
        # sub_sub_nav: 'lightschool_nav'
        main: 'decks'

FlowRouter.route '/lightschool/exercises', action: ->
    BlazeLayout.render 'layout',
        # sub_nav: 'member_nav'
        # sub_sub_nav: 'lightschool_nav'
        main: 'exercises'


# FlowRouter.route '/lightschool/courses', action: ->
#     BlazeLayout.render 'layout',
#         sub_nav: 'member_nav'
#         sub_sub_nav: 'lightschool_nav'
#         main: 'courses'
