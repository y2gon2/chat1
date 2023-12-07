defmodule Chat1Web.HomeLive do
  use Chat1Web, :live_view


  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}))}
  end

  def handle_event("goto_topic", %{"topic" => topic_name}, socket) do
    topic_link = "/topic_name/" <> topic_name

    {:noreply, push_navigate(socket, to: topic_link)}
  end

end
