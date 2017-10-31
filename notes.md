meteor deploy --settings settings.json www.toriwebster.com


<!--image-->
db.users.find({ image_id:{$exists:true}, profile: {$exists:true} }).forEach(
    function(doc) {
        doc.profile.image_id = doc.image_id;
        db.users.save(doc);
    }
)


<!--db.docs.find({ type: 'module', course_id: 'sW4accx4fvZBK6wLn' }).count()-->
db.docs.find({ type: 'module', course_id: 'sW4accx4fvZBK6wLn' }).count()
db.docs.find({ tags }).forEach(
    function(doc) {
        doc.parent_id = 'njW3pz6w5QenaDwMw'
        db.docs.save(doc);
    }
)

db.docs.updateMany( {}, { $rename: { "body": "content" } } )
Docs.updateMany( {}, { $rename: { "parent_type": "child_view" } } )

Docs.update({"parent_type": {$exists:true}}, { $rename: {"parent_type": "child_view"} }, {multi:true})
Docs.update({"child_view": "twig"}, { $set: {"child_view": "list"} }, {multi:true})
Docs.update({"child_view": "branch"}, { $set: {"child_view": "grid"} }, {multi:true})

db.docs.find({ tags:{$in:['reflective', 'question']} }).forEach(
db.docs.find({ tags:"['reflection', 'question']" }).forEach(
    function(doc) {
        var index = doc.tags.indexOf('lightbank');
        doc.tags.splice(index, 1);
        doc.type = 'lightbank';
        db.docs.save(doc);
    }
)


db.docs.find({ tags:"['reflection', 'question']"}).forEach(
    function(doc) {
        doc.tags = ['reflection', 'question'];
        db.docs.save(doc);
    }
)

Docs.update({tags: {$all:["question", "reflection"]}}, {$set: {type:"reflective_question"}}, {multi: true})


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
    
    


flow from demo button
birthday under location


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


todo
    comparison with tags and colors
    
meteor add bundle-visualizer



get to karma
points for completing sections, excercises
flow
dashboard, attention empowering, being seen
journal evoke activity, get to know people, lead to meaning 
check in
    suggested tags, brians system
    

person tags
document tag rating
working request tori feedback feature
    send message, email message to tori,
    transaction mark complete
transaction review, voting and tags
    transaction child documents
messaging system to conversations

! read by stats with numbers !

profile sections review
child doc component for docs (journal entries), conversation view under lightbank, 
    'start conversation about this'
    public
    inherit tags
    include author
date array tag facet
karma
    send point
    tip amount for documents
    
    
services
    tori 1on1
    price
    scheduling
stats and badges
    ?
    
global read count
    read activation on click
    segment view 
    
    
    
Docs.find({tags:["section"]}).count()
Docs.update({tags:["section"]}, {$set:{type:'section'}}, {multi:true})



{
  "_id": "NZaqaeYyGdnBm4cJJ",
  "tags": [
    "sol",
    "module 4",
    "module progress"
  ],
  "author_id": "5xrn6pFLKF95mrpcj",
  "module_progress_percent": 66.66666666666666,
  "module_section_count": 5,
  "section_complete_count": 3,
  "module_sections_complete": false,
  "debrief_question_count": 1,
  "debrief_answer_count": 1,
  "module_debrief_complete": true,
  "lightwork_question_count": 3,
  "lightwork_answer_count": 0,
  "module_lightwork_complete": false,
  "parent_id": "2eXMhxuv4LW4jWobr",
  "type": "module_progress"
}


approve bug
get 5 points
create transaction
notifiy author
how many points?

user macro settings

tori point settings

offer 'bug report' in shop
reward = will pay

requests
needs!

bounties


bring the code to the surface
badges track progress, based off of a db query, -> create tw programming language
connect the human to the upper realm

sections
components
collections
items

nav menu
    has to attach to doc_template
    course_module
        nav_menu
            sections
            debrief
            lightwork
            
Docs.update({type:'lightbank'}, {$set:{parent_id:'nNSRYhiaya25BC2sA'}}, {multi:false})            
Docs.update({type:'checkin'}, {$set:{parent_id:'jcZAas8DMrB89gScD'}}, {multi:true})            
Docs.update({type: "journal", parent_id: { "$exists": false }}, {$set:{parent_id:'nzFBF5wGLceZ5jFoE'}}, {multi:true})            


automated therapy