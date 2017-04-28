FlowRouter.route '/privacy', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'privacy'

FlowRouter.route '/terms-of-use', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'terms-of-use'




AccountsTemplates.configure
    defaultLayout: 'layout'
    # defaultLayoutRegions:
        # nav: ''
    defaultContentRegion: 'main'
    showForgotPasswordLink: false
    overrideLoginErrors: true
    enablePasswordChange: true

    # Appearance
    showAddRemoveServices: false
    showForgotPasswordLink: true
    showLabels: true
    showPlaceholders: false
    showResendVerificationEmailLink: true


    sendVerificationEmail: true
    enforceEmailVerification: false
    confirmPassword: true
    continuousValidation: true
    #displayFormLabels: true
    #forbidClientAccountCreation: true
    # formValidationFeedback: true

    negativeValidation: true
    positiveValidation: true
    negativeFeedback: true
    positiveFeedback: true

    # Privacy Policy and Terms of Use
    # privacyUrl: 'privacy'
    termsUrl: 'terms-of-use'

pwd = AccountsTemplates.removeField('password')
AccountsTemplates.removeField 'email'
AccountsTemplates.addFields [
    # {
    #     _id: 'first_name'
    #     type: 'text'
    #     displayName: 'First Name'
    #     required: true
    #     minLength: 3
    # }
    # {
    #     _id: 'last_name'
    #     type: 'text'
    #     displayName: 'Last Name'
    #     required: true
    #     minLength: 3
    # }
    # {
    #     _id: 'location'
    #     type: 'text'
    #     displayName: 'Location'
    #     required: false
    #     minLength: 3
    # }
    {
        _id: 'username'
        type: 'text'
        displayName: 'username'
        required: true
        minLength: 3
    }
    {
        _id: 'email'
        type: 'email'
        required: true
        displayName: 'email'
        re: /.+@(.+){2,}\.(.+){2,}/
        errStr: 'Invalid email'
    }
    {
        _id: 'username_and_email'
        type: 'text'
        required: false
        displayName: 'Login (username or email)'
    }
    pwd
]


AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'forgotPwd'

AccountsTemplates.configureRoute 'resetPwd'


AccountsTemplates.configureRoute('signIn', {
  redirect: '/dashboard',
});

AccountsTemplates.configureRoute('signUp', {
  redirect: '/account/profile/edit',
});


AccountsTemplates.configureRoute 'verifyEmail'

