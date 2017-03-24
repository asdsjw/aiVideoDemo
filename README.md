# aiVideoDemo
爱视频的核心部件,演示JS构建播放器和自定义加载进度模版

asdsjw

Apple TV4(tvos)的一份演示代码,于2016.8创建,经过一年时间测试效果良好

另外里面有一个tvos10.0新增加的API,恢复时间提示框使用该API演示

这段时间研究另外一个app,这样差不多七七八八TVML 框架比较清晰了

祝大家TVML之旅愉快!!!😄😄😄😄😄

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
