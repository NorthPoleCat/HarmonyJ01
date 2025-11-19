function appendCss(str) {
    // alert(str);
    var param = str.split(",");
    for (var path in param) {
        var head = document.getElementsByTagName('head')[0];
        var link = document.createElement('link');
        link.href = param[path];
        link.rel = 'stylesheet';
        link.type = 'text/css';
        head.appendChild(link);
    }
}

function setFont(progress) {
    var d = document.getElementById('Content');
    d.style.fontSize = progress+'%';
}

function checkImg(playing,recycle) {
    var obj = document.getElementsByClassName('bottom_audio_child');
    for(var i=0 ; i<obj.length ; i++) {
        if (playing > 0) {
            obj[i].children[0].src = "../img/suspend.png";
        } else {
            obj[i].children[0].src = "../img/play.png";
        }

        if (recycle > 0) {
            obj[i].children[2].src = "../img/recycle.png";
        } else {
            obj[i].children[2].src = "../img/anti-recycle.png";
        }
    }
}

window.onload = function() {
    jsBridge.loadCss();
}
