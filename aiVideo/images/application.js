var baseUrl;
App.onLaunch = function(options) {
    baseUrl=options.baseUrl;
    let xml=`<document>
  <head>
    <style>
    .showTextOnHighlight {
      tv-text-highlight-style: show-on-highlight;
    }
    .badge {
      tv-tint-color: rgb(0,0,0);
    }
    .9ColumnGrid {
      tv-interitem-spacing: 51;
    }
    </style>
  </head>
  <productTemplate>
    <background>
      <img src="http://desk.fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/0F/09/ChMkJlauzbOIb6JqABF4o12gc_AAAH9HgF1sh0AEXi7441.jpg" />
    </background>
    <banner>
      <infoList>
        <info>
          <header>
            <title>genre</title>
          </header>
          <text>Genre Name</text>
        </info>
        <info>
          <header>
            <title>director</title>
          </header>
          <text>Director Name</text>
        </info>
        <info>
          <header>
            <title>starring</title>
          </header>
          <text>Actor 1</text>
          <text>Actor 2</text>
          <text>Actor 3</text>
          <text>Actor 4</text>
          <text>Actor 5</text>
        </info>
      </infoList>
      <stack>
        <title>创建自定义的JS Player播放器 和 自定义loadingTemplate</title>
        <!-- In lieu of title an image can be used of size max dimensions of 846x130 -->
        <!-- <img src="" width="846.0" height="130.0" /> -->
        <row>
          <text><badge src="resource://tomato-fresh" style="margin:0 0 -3"/> 90%</text>
          <text>Text 1</text>
          <text>Text 2</text>
          <text>Text 3</text>
          <badge src="resource://mpaa-pg" class="badge" />
          <badge src="resource://cc" class="badge" />
        </row>
        <description handlesOverflow="true">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim.</description>
        <row>
          <buttonLockup onselect="playerDemo()">
            <badge src="resource://button-play" />
            <title>2016.8</title>
          </buttonLockup>
          <buttonLockup>
            <badge src="resource://button-add" />
            <title>Title 3</title>
          </buttonLockup>
        </row>
      </stack>
    </banner>
  </productTemplate>
</document>`;
pushXmlDocument(xml);
};


function pushXmlDocument(xml) {
	var parser = new DOMParser();
    var doc = parser.parseFromString(xml, "application/xml");
    navigationDocument.pushDocument(doc);
}



function playerDemo()
{
    const player=new JSPlayer();
    player.playlist = new JSPlaylist();
    //是否启用下一集宫
	player.skipForward=false;
	//是否启用恢复时间提示框
	player.resumeTime=false;
	//是否启用时钟提示
	player.modalOverlayClock="开";
	//显示窗体
	player.present();
	//播放地址临时点,随时失效
	const mediaItem = new JSMediaItem("video", "http://222.186.39.217/225/13/105/letv-uts/14/ver_00_22-1091346370-avc-389653-aac-48000-1286080-72323323-fb395c69bd93e88f677d4ca1bd3e6158-1490174999874.m3u8?crypt=95aa7f2e505&b=449&nlh=4096&nlt=60&bf=90&p2p=1&video_type=mp4&termid=2&tss=ios&platid=3&splatid=304&its=0&qos=4&fcheck=0&amltag=4702&mltag=4702&proxy=3736741852,3026207899,1786224549&uid=3736900977.rp&keyitem=GOw_33YJAAbXYE-cnQwpfLlv_b2zAkYctFVqe5bsXQpaGNn3T1-vhw..&ntm=1490339400&nkey=06b73b4eb8a2947a9921e95284b84ccf&nkey2=55ccb4c0076b4bb667dd29a79ffafd59&geo=CN-10-538-1&mmsid=63676099&tm=1490320973&key=1055bc1d5f2720a1f11f6f353ab25322&playid=0&vtype=13&cvid=923721950130&payff=0&p1=0&p2=06&ostype=macos&hwtype=un&uuid=1320980349512137&vid=28361665&errc=0&gn=1027&vrtmcd=102&buss=4702&cips=222.188.149.113");
	mediaItem.title = "测试标题";
	player.playlist.push(mediaItem);
	player.play();
	//更改播放器提示
	//player.changStatusText("解析直播失败pic!");
}