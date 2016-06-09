/* https://github.com/pketh/github-report-card
 */

$( document ).ready(function() {

  var username = $('.gh-username').text();

  var gistsURL = "https://gist.github.com/" + username;
  var reposURL = "https://github.com/" + username +"?tab=repositories";

  var userPath = "https://api.github.com/users/" + username;
  var reposPath = "https://api.github.com/users/" + username + "/repos";

  var languages = [];
  var languageNameMapping = {
      'C++': 'cpp',
      'C#': 'C Sharp',
  }

  target = "target='_blank' "

  // get user profile json
  $.getJSON(userPath, function(userResult){

    // avatar pic
    var avatar = userResult.avatar_url;
    $('.gh-avatar').html("<a " + target + "href=" + profileURL + "><img src='" + avatar + "'></a>");

    // profile
    var profileURL = userResult.html_url;
    $('.gh-username').html("<a " + target + "href='" + profileURL + "'>" + username + "</a>");

    var followers = userResult.followers;
    var followersURL = userResult.followers_url;
    $('.gh-followers').html("<a " + target + "href='" + followersURL + "'>" + followers + " Followers</a>")
    $('.gh-followers').html(followers + " Followers")

    var reposNum = userResult.public_repos;
    $('.gh-repos').html("<a " + target + "href='" + reposURL + "'>" + reposNum + " Repositories</a>")
    var gistsNum = userResult.public_gists;
    $('.gh-gists').html("<a " + target + "href='" + gistsURL + "'>" + gistsNum + " Gists</a>")
  });

  // get languages for all repos from github
  $.getJSON(reposPath, function(reposResult){
    reposResult.forEach (function(obj){
      if(obj.language && obj.language !== 'undefined') {
        languages.push(obj.language)
      }
    });
    var languagesSorted = languages.byCount();
    var maxNumberOfLanguages = getMaxLanguages(languagesSorted);
    
    for (var i = 0; i < maxNumberOfLanguages; i++) {
      var languagesOutput;
      var languageColor = getLanguageColor(languagesSorted[i])
      var color = '<div class="gh-color" style="background-color:' + languageColor + '"></div> ';
      if (i === maxNumberOfLanguages - 1) {
         languagesOutput = '<div class="gh-language-block">' + color + languagesSorted[i] + '</div>'
      } else {
        languagesOutput = '<div class="gh-language-block">' + color + languagesSorted[i] + ', '  + '</div> '
      }
      $('.gh-languages').append(languagesOutput)
    }

    function getMaxLanguages(languages) {
      var maxLanguages = 20
      if (languages.length > maxLanguages) {
        return maxLanguages
      } else {
        return languages.length
      }
    }

    function getLanguageColor(languageName) {
      var color = githubLanguageColors[languageName]
      if (color) {
          return githubLanguageColors[languageName];
      } else {
          // language not found, try synonym
          languageName = languageNameMapping[languageName];
          return githubLanguageColors[languageName];
      }
    }

  });

  // returns most frequent to least frequent
  Array.prototype.byCount= function(){
    var itm, a= [], L= this.length, o= {};
    for(var i= 0; i<L; i++){
      itm= this[i];
      if(!itm) continue;
      if(o[itm] === undefined) o[itm]= 1;
      else ++o[itm];
    }
    for(var p in o) a[a.length]= p;
    return a.sort(function(a, b){
      return o[b]-o[a];
    });
  }

});
