DEPLOY_HOSTNAME=us-east-1.galaxy-deploy.meteor.com meteor deploy --settings settings.json www.toriwebster.com


<!--image-->
db.users.find({ image_id:{$exists:true}, profile: {$exists:true} }).forEach(
    function(doc) {
        doc.profile.image_id = doc.image_id;
        db.users.save(doc);
    }
)


db.docs.find({ type: 'module', course_id: 'sW4accx4fvZBK6wLn' }).count()
db.docs.find({ parent_id: 'HQ3qAPuBijtZ8LGiX' }).forEach(
    function(doc) {
        doc.parent_id = 'njW3pz6w5QenaDwMw'
        db.docs.save(doc);
    }
)

db.docs.updateMany( {}, { $rename: { "body": "content" } } )



db.docs.find({ tags:{$in:['lightbank']} }).forEach(
    function(doc) {
        var index = doc.tags.indexOf('lightbank');
        doc.tags.splice(index, 1);
        doc.type = 'lightbank';
        db.docs.save(doc);
    }
)


db.docs.find({ tags:["green"]} }).forEach(
    function(doc) {
        doc.tags = "[green]";
        db.docs.save(doc);
    }
)

facetadmin
FRHuvjHTCNouzmFJ

db.docs.find({ tags:{$exists:true} }).count()


db.users.find({ courses:{$in:["sW4accx4fvZBK6wLn]} }).count()



db.docs.find({ test_id: "daj5G56YWA35mGLYL" }).count()


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
        
        
flow from demo button
settings under account
email in profile
birthday under location
toggle for email public
zen quotes
password change
username change
tests
posts in dashboard


Light purple
#927379
Dark purple
#47334E
Scarlet red
#FF414d
Orange
#FF9C24
Turquoise 
#1AA6b7
Grey teal
#357591
Night blue
#002d40
