const gruvboxColors = [
  "#b8bb26",
  "#fabd2f",
  "#83a598",
  "#d3869b",
  "#8ec07c",
  "#458588",
  "#cc241d",
  "#d65d0e",
  "#bdae93",
];
const generateGruvboxFromString = (string) => 
  gruvboxColors[Array.from(string).map((x) => x.charCodeAt(0)).reduce((a, x) => a+x, 0) % gruvboxColors.length];

const RoomChat = (() => {
  let channel;
  const connect = (socket, postId) => {
    channel = socket.channel(`post:${postId}`);
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully: ", resp); })
      .receive("error", resp => { console.log("Unable to join: ", resp); });
    return channel;
  };

  const scrollToBottom = (element) => {
    element.scrollTop = element.scrollHeight;
  };

  const appendComment = ({user, body, id, user_id, inserted_at}, element) => {
    const messageElement = document.createElement("div");
    messageElement.innerHTML = `
      <div class="d-flex flex-row card border rounded m-2 align-items-center">
        <div class="m-2">
          <div class="circle" style="background:${generateGruvboxFromString(user)}">${user.charAt(0)}</div>
        </div>
        <div class="m-2">
          <div class="comment">
            <div class="comment-header">
              <span class="comment-username">${user}</span>
              <span class="text-muted">${new Date(inserted_at).toLocaleString()}</span>
            </div>
            <div class="comment-body">
              ${body}
            </div>
          </div>
        </div>
      </div>
    `;
    element.appendChild(messageElement);
    scrollToBottom(element);
  };

  const leaveChannel = () => {
    if (channel) {
      channel.leave();
      console.log(channel);
    }
  };

  const main = (post_id) => {
    leaveChannel();
    const chatWindow = document.getElementById("chat");
    window.userSocket.connect();
    channel = connect(window.userSocket, post_id);
  
    channel.on('shout', (comment) => {
      appendComment(comment, chatWindow);
    });
  
    channel.on('initial-comments', ({comments}) => {
      comments.forEach((comment) => {
        appendComment(comment, chatWindow);
      });
      scrollToBottom(chatWindow);
    }); 

    channel.on('join', ({ user }) => {
      const joinElement = document.createElement("div");
      joinElement.innerHTML = `
        <div class="m-2 card border rounded p-2 text-muted">
          join: ${user}
        </div>
      `;
      chatWindow.appendChild(joinElement);
      scrollToBottom(chatWindow);
    }); 

    channel.on('left', ({ user }) => {
      console.log(user, "left");
    });
  };

  const submitForm = (e) => {
    e.preventDefault();
    let message = e.target.elements.message.value;
    if (message) {
      channel.push("send", {body: message});
      e.target.elements.message.value = "";
    }
    return false;
  };

  return { main, submitForm };
})();

window.addEventListener('load', () => {
  window.addEventListener('phx:initial-post', (e) => RoomChat.main(e.detail.id));
});

export default RoomChat;
