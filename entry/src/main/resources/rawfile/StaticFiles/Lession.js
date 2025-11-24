function grammarClick(e) {
    var grammarStr = e.getAttribute("grammar");
    jsBridge.grammar(grammarStr);
}

function wordClick(e) {
    var wordNumStr = e.getAttribute("wordNum");
    // var param = {
    //     wordNum: wordNumStr,
    // }
    // window.webkit.messageHandlers.word.postMessage(param);
    jsBridge.word(wordNumStr);
}

function sentenceClick(e) {
    var senNumStr = e.getAttribute("senNum");
    jsBridge.sentence(senNumStr)
}

function playClick(e) {
    //修改图标
    var audioNum = e.getAttribute("audioNum");

    var obj = document.getElementsByClassName('bottom_audio_child');

    if(e.src.search("play.png") != -1) {
        for(var i=0 ; i<obj.length ; i++) {
            obj[i].children[0].src = "../img/suspend.png";
        }
    } else {
        for(var i=0 ; i<obj.length ; i++) {
            obj[i].children[0].src = "../img/play.png";
        }
    }

    setSenAudioPic('00-00');

    jsBridge.audioPlay();
    // window.webkit.messageHandlers.audioPlay.postMessage(audioNum);
}

function sentenceAudio(e) {
    var audioNum = e.getAttribute('senNum');

    setAudioPic('00-00');
    setSenAudioPic(audioNum);

    var param = 'sen:'+audioNum;

    window.webkit.messageHandlers.senAudioPlay.postMessage(param);
}

function setAudioPic(e) {
    var obj = document.getElementsByClassName('bottom_audio_child');
    for(var i=0 ; i<obj.length ; i++) {
        if (obj[i].children[0].getAttribute('audioNum') == e) {
            obj[i].children[0].src = "../img/suspend.png";
        } else {
            obj[i].children[0].src = "../img/play.png";
        }
    }
} 

function setSenAudioPic(e) {
    var sen = document.getElementsByClassName('senAudio');
    for(var i=0 ; i<sen.length ; i++) {
        if (sen[i].getAttribute('senNum') == e) {
            sen[i].src = "../img/sound-play.png";
        } else {
            sen[i].src = "../img/sound-sus.png";
        }
    }
}

function resetClick(e) {
    //修改图标
    // var play = e.parentNode.children[0];
    // play.src = "../img/play.png";
    var obj = document.getElementsByClassName('bottom_audio_child');
    for(var i=0 ; i<obj.length ; i++) {
        obj[i].children[0].src = "../img/play.png";
    }
    window.webkit.messageHandlers.audioReset.postMessage("");
}

function recycleClick(e) {
    //修改图标
    var obj = document.getElementsByClassName('bottom_audio_child');

    if (e.src.search("anti-recycle.png") != -1) {
        for(var i=0 ; i<obj.length ; i++) {
            obj[i].children[2].src = "../img/recycle.png";
        }
    } else {
        for(var i=0 ; i<obj.length ; i++) {
            obj[i].children[2].src = "../img/anti-recycle.png";
        }
    }
    window.webkit.messageHandlers.audioRecycle.postMessage("");
}

function fold(e) {
    var type = e.getAttribute("tabType");
    var element = document.getElementById("tabCss");
    var target = '../StaticFiles/'+type+'.css';
    element.setAttribute("href",target);
    scrollTo(0,0);
}
