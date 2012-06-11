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
