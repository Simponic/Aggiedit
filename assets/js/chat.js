let RoomChat = {
  connect(socket, postId) {
    let channel = socket.channel(`post:${postId}`)
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully: ", resp) })
      .receive("error", resp => { console.log("Unable to join: ", resp) })
    return channel;
  },
}

export default RoomChat;