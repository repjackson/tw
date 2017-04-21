DEPLOY_HOSTNAME=us-east-1.galaxy-deploy.meteor.com meteor deploy --settings settings.json www.toriwebster.com


<!--image-->
db.users.find({ image_id:{$exists:true}, profile: {$exists:true} }).forEach(
    function(doc) {
        doc.profile.image_id = doc.image_id;
        db.users.save(doc);
    }
)


db.docs.find({ type:{$exists:false} }).forEach(
    function(doc) {
        doc.type = 'article';
        db.docs.save(doc);
    }
)


db.docs.find({ type:{$exists:false} }).count()


mongo --ssl --sslAllowInvalidCertificates aws-us-east-1-portal.21.dblayer.com:10444/toridb -u toriadmin -pTurnf34ragainst!


mongodb://facet:<password>@aws-us-east-1-portal.21.dblayer.com:10444/facetdb?ssl=true


    
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
    
    


tests notes
    each answer is a document with sessionID, question_id, answer, userID, makes it easy for any analytics
    each test has a dashboard showing sessions, statistics (user and total), 
    test creater app, add questions, add type of answer
    each session has results doc? probably just in the same doc, with finished boolean
    when finished, can publish results, adds badge to user profile
    future tests
        english competency
        math skills
        office skills
        any business related/beneficial skill, aim is to build ability, empower people
        
        
meeting notes
    marketplace
    inspire u
        courses
        tests
    stable sol link
    
    
todo today
    remove unneeded components