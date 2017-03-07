const Botkit = require('botkit');
const exec = require('child_process').exec;
const execsyncs = require('execsyncs');
const fs = require('fs');
const my_token = 'my-token'
const root_path = '/home/pi/Projects/pi-pet-care/'
const image_file = root_path + 'graph/temparature_graph.png'

const controller = Botkit.slackbot({
    debug: false
});

controller.spawn({
    token: my_token
}).startRTM(function(err){
    if(err) {
	throw new Error(err);
    }
});

// respond to request
controller.hears(["寒い？","暑い？"], ['direct_message', 'direct_mention', 'mention'], function(bot,message) {
  exec('ruby /home/pi/Projects/pi-pet-care/Controller.rb bot',
       function(err, stdout, stderr){
         if (err) { console.log(err); }
         var result = stdout.toString();
         bot.reply(message,result);
       });
});
controller.hears(["グラフ"], ['direct_message', 'direct_mention', 'mention'], function(bot,message) {
  // syncroniously execute ruby script to create graph image file
  execsyncs('ruby /home/pi/Projects/pi-pet-care/graph/create_temparature_chart.rb');
  fs.readFile(image_file, function(err,data){
    if(err) throw err;

    bot.api.files.upload({
      file: fs.createReadStream(image_file),
      filename: 'temparature_graph.png',
      channels: message.channel
    },function(err,res) {
      if(err) console.log(err)
    })
  });
});
