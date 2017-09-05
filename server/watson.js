var NaturalLanguageUnderstandingV1 = require('watson-developer-cloud/natural-language-understanding/v1.js');
var natural_language_understanding = new NaturalLanguageUnderstandingV1({
  'username': Meteor.settings.private.language.username,
  'password': Meteor.settings.private.language.password,
  'version_date': '2017-02-27'
});

// var parameters = {
//   'text': 'IBM is an American multinational technology company headquartered in Armonk, New York, United States, with operations in over 170 countries.',
//   'features': {
//     'entities': {
//       'emotion': true,
//       'sentiment': true,
//       'limit': 2
//     },
//     'keywords': {
//       'emotion': true,
//       'sentiment': true,
//       'limit': 2
//     }
//   }
// }
Meteor.methods({
    call_watson: function(parameters, doc_id){
        // console.log(Meteor.settings.private.language.username);
        // console.log(Meteor.settings.private.language.password);
        natural_language_understanding.analyze(parameters, Meteor.bindEnvironment(function(err, response) {
          if (err)
            console.log('error:', err);
          else
            var result = (JSON.stringify(response, null, 2));
            Docs.update({_id:doc_id},
                {$set: {watson:result}}
            )
    }));
      
  }
    
})
