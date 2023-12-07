defmodule Chat1Web.TopicLive do
  # use Phoenix.LiveView, layout: false
  use Chat1Web, :live_view
  require Logger

  def mount(%{"topic_name" => topic_name}, _session, socket) do
    # Logger.info(params: params) # [info] [params: %{"topic_name" => "afa"}]

    user_number = :rand.uniform(10) |> to_string
    username = "user_" <> user_number

    if connected?(socket) do
      # 현재 LiveView를 주어진 토픽에 구독시킵니다.
      Chat1Web.Endpoint.subscribe(topic_name)
      Chat1Web.Presence.track(self(), topic_name, username, %{}) # %{} : meta data
    end

    {
      :ok,
      assign(
        socket,
        topic_name: topic_name,
        username: username,
        users_online: [],
        message: "",
        chat_messages: %{msg: nil, username: nil, uuid: nil},
        # temporary_assigns: [chat_messages: []],
        form: to_form(%{})
      )
    }
  end

  def handle_event("submit_message", %{"message" => message}, %{assigns: %{username: username}} = socket) do
    Logger.info(submit_message: message)
    message_data = %{msg: message, username: username, uuid: UUID.uuid1()}

    Chat1Web.Endpoint.broadcast(socket.assigns.topic_name, "new_message", message_data)

    {:noreply, assign(socket, message: "")}
  end

  def handle_event("on_texting", %{"message" => message}, socket) do
    # Logger.info(on_texting: message)
    {:noreply, assign(socket, message: message)}
  end

  # 받은 메시지를 소켓 상태에 추가합니다.
  def handle_info(%{event: "new_message", payload: message_data}, %{assigns: %{chat_messages: chat_messages}} = socket) do
    # Logger.info(message_data: message_data)
    Logger.info(chat_messages: chat_messages)

    {:noreply, assign(socket, chat_messages: message_data)}
  end

  def handle_info(%{event: "presence_diff"}, %{assigns: %{topic_name: topic_name}} = socket) do
    users_online = Chat1Web.Presence.list(topic_name)
      |> Map.keys()
    Logger.info(presence_diff: users_online)
    {:noreply, assign(socket, users_online: users_online)}
  end

  def user_msg_heex(assigns) do
    Logger.info(assigns: assigns)

    ~H"""
      <li id={@msg_data.uuid} class={"relative #{if @msg_data.username == @me, do: "bg-white ml-40", else: "bg-green-300 mr-40"} mb-2 py-5 px-4 border rounded-xl"}>
        <div class="flex justify-between space-x-3">
        <div class="min-w-0 flex-1">
            <a href="#" class="block focus:outline-none">
            <span class="absolute inset-0" aria-hidden="true"></span>
            <p class="truncate text-sm font-medium text-gray-900 mb-4">[<%= @msg_data.username %>]</p>
            </a>
        </div>
        </div>
        <div class="mt-1">
        <p class="text-sm text-gray-600 line-clamp-2"><%= @msg_data.msg %></p>
        </div>
      </li>
    """
  end
end
