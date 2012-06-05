/**
 * javascript by gelegele
 */

// ページロード時
window.onload = function(){
  activateNavTab();
}

// URLに該当するNAVI TAB をアクティブにする
function activateNavTab() {
  var slashIndex = location.href.lastIndexOf("/");
  var questionIndex = location.href.lastIndexOf("?");
  // ホスト名に続く
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


// 外部リンクを別タブで開く
$(function(){
     $("a[href^='http://']").attr("target","_blank");
});
