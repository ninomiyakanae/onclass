document.addEventListener("DOMContentLoaded", function() {
  // ポップアップの基本構造を作成
  var popup = document.createElement('div');
  popup.id = 'popup';
  popup.className = 'popup';
  popup.style.display = 'none';
  popup.innerHTML = `
    <div class="popup-content">
      <span class="close">&times;</span>
      <div id="popup-body"></div>
    </div>
  `;
  document.body.appendChild(popup);

  var span = popup.getElementsByClassName("close")[0];
  
  // 閉じるボタンがクリックされたときの処理
  span.onclick = function() {
    popup.style.display = "none";
  };
  
  // ポップアップの外側がクリックされたときの処理
  window.onclick = function(event) {
    if (event.target == popup) {
      popup.style.display = "none";
    }
  };

  // data-popup属性を持つリンクに対してイベントリスナーを追加
  document.querySelectorAll('a[data-popup]').forEach(function(link) {
    link.addEventListener('ajax:success', function(event) {
      var data = event.detail[2].responseText;
      document.getElementById('popup-body').innerHTML = data;
      popup.style.display = 'block';
    });
  });
});
