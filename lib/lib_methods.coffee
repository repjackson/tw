Meteor.methods
    send_point: (id)->
        doc = Docs.findOne id
        # check if current user has sent points
        if doc.donators and Meteor.userId() in doc.donators
            Docs.update {
                _id: id
                "donations.user": Meteor.userId()
                },
                    $inc:
                        "donations.$.amount": 1
                        points: 1
            Meteor.users.update Meteor.userId(), $inc: points: -1
            Meteor.users.update doc.authorId, $inc: points: 1

        else
            Docs.update id,
                $addToSet:
                    donators: Meteor.userId()
                    donations:
                        user: Meteor.userId()
                        amount: 1
            Meteor.users.update Meteor.userId(), $inc: points: -1
            Meteor.users.update doc.authorId, $inc: points: 1


    retrieve_point: (id)->
        doc = Docs.findOne id
        currentId = Meteor.userId()
        # check if current user has sent points
        if doc.donators and Meteor.userId() in doc.donators
            donationEntry = _.find doc.donations, (donation)->
                donation.user is currentId
            if donationEntry.amount is 1
                Docs.update {
                    _id: id
                    "donations.user": Meteor.userId()
                    },
                    $pull: { donations: {user: Meteor.userId()}, donators: Meteor.userId()}
                    $inc: points: -1

                Meteor.users.update Meteor.userId(), $inc: points: 1
                Meteor.users.update doc.authorId, $inc: points: -1

            else
                Docs.update {
                    _id: id
                    "donations.user": Meteor.userId()
                    }, $inc: "donations.$.amount": -1, points: -1

                Meteor.users.update Meteor.userId(), $inc: points: 1
                Meteor.users.update doc.authorId, $inc: points: -1

    updatelocation: (docid, result)->
        addresstags = (component.long_name for component in result.address_components)
        loweredAddressTags = _.map(addresstags, (tag)->
            tag.toLowerCase()
            )

        #console.log addresstags

        doc = Docs.findOne docid
        tagsWithoutAddress = _.difference(doc.tags, doc.addresstags)
        tagsWithNew = _.union(tagsWithoutAddress, loweredAddressTags)

        Docs.update docid,
            $set:
                tags: tagsWithNew
                locationob: result
                addresstags: loweredAddressTags

