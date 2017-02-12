DEPLOY_HOSTNAME=us-east-1.galaxy-deploy.meteor.com meteor deploy --settings settings.json www.wateringhole.community


<!--image-->
db.users.find({ image_id:{$exists:true}, profile: {$exists:true} }).forEach(
    function(doc) {
        doc.profile.image_id = doc.image_id;
        db.users.save(doc);
    }
)




mongo --ssl --sslAllowInvalidCertificates aws-us-east-1-portal.21.dblayer.com:10444/facetdb -u facetadmin -pTurnf34ragainst!


mongodb://facet:<password>@aws-us-east-1-portal.21.dblayer.com:10444/facetdb?ssl=true


notes
    member matching on edit page
    check in process for members
    check in process for guests
        name
        email
        associated member
            notify member via text/email

todo
    remote editing mode for guest that just checked in
    
    
my thoughts
    love game concept, everything you do is for a purpose, thus has value, thus should be rewarded/incentivized
    transaction goal is p2p, start with b2p, ie, get points (going to event, adding post) cash in with local business
    business can provide coupon for member with certain tag points
    
    structure idea
        add post, each upvote gets points
        points can be used in the marketplace, not p2p at first, basically get stuff for participating
        and have leaderboards
        
        
ultimate goal
    have member compete for points per tags
    
    
notes
    user submitted guides and posts
    community forum for positivity
    problems can be tagged
    need comments, blog, feed
    $10/month online access to community
    $100 for course
    reputation points can be used to purchase things that are sponsored