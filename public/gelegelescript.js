/**
 * javascript by gelegele
 */

// �y�[�W���[�h��
window.onload = function(){
  activateNavTab();
}

// URL�ɊY������NAVI TAB ���A�N�e�B�u�ɂ���
function activateNavTab() {
  var slashIndex = location.href.lastIndexOf("/");
  var questionIndex = location.href.lastIndexOf("?");
  // �z�X�g���ɑ���
  var pageName;
  if (0 <= questionIndex) {
    // ���N�G�X�g�p�����[�^�t��URL
    pageName = location.href.slice(slashIndex + 1, questionIndex);
  } else {
    // ���N�G�X�g�p�����[�^�Ȃ�URL
    pageName = location.href.substr(slashIndex + 1);
  }
  var tab = document.getElementById("tab-" + pageName);
  tab.className = "active";
}

