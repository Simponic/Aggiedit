let RoomChat = {
  init(socket, postId) {
    console.log(postId);
    console.log(socket);
    let channel = socket.channel(`post:${postId}`)
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
    this.listenForChats(channel)
  },
  addMessage(user, message) {
//    let body = `<span class="username"><b>${user}</b></span>: ${message}<br>`
//    if (message.match(new RegExp(`@${window.userName}`, "ig"))) {
//      $("#chat-box").append('<p class="chat-entry"><span class="mentioned">' + body + '</span></p>')
//    } else {
//      $("#chat-box").append('<p class="chat-entry">' + body + '</p>')
//    }
  },
  scrollBottom() {
//    $("#chat-box").animate({ scrollTop: $('#chat-box').prop("scrollHeight")}, 200)
  },
  listenForChats(channel) {
    channel.push('send', { body: "HELLO"});
//    $(() => {
//      $("#chat-form").on("submit", function(ev) {
//        ev.preventDefault()
//
//        let userMsg = $('#user-msg').val()
//        channel.push('send', {body: userMsg})
//
//        $("#user-msg").val("")
//      })

//      channel.on('shout', function(payload) { 
//        console.log(payload)
//        RoomChat.addMessage(payload.name, payload.body)
//        RoomChat.scrollBottom()
//      })
 //   })
    channel.on('shout', function(payload) { 
      console.log(payload)
    });
  }
}

export default RoomChat;