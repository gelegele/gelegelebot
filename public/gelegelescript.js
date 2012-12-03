/**
 * javascript by gelegele
 */

// 外部リンクを別タブで開く
function externalLinkTargetBlank() {
    $("a[href^='http://']").attr("target","_blank");
}

// URLに該当するNAVI TAB をアクティブにする
function activateNavTab() {
  var slashIndex = location.href.lastIndexOf("/");
  var questionIndex = location.href.lastIndexOf("?");
  var pageName;
  if (0 <= questionIndex) {
    // リクエストパラメータ付きURL
    pageName = location.href.slice(slashIndex + 1, questionIndex);
  } else {
    // リクエストパラメータなしURL
    pageName = location.href.substr(slashIndex + 1);
  }
  var tab = document.getElementById("tab-" + pageName);
  tab.className = "active";
}

// fav/unfavボタン
function postFav(id, favorited) {
  var url = 'unfavorite';
  if (!favorited) {
    url = 'favorite';
  }
  alert(url);
  $.ajax({
      type: 'POST',
      url: url,
      data: {'id': id},
      success: function(data){alert("OK")},
      error: function(data){alert("NG")}
    });
}

window.onload = function(){
  $(externalLinkTargetBlank());
  activateNavTab();
  $.autopager({
      content: '.tweets',
      link   : 'a.next',
      load   : function() {
          $(this).ready(externalLinkTargetBlank());
          $("div.next:first").remove();
      }
  });
}
