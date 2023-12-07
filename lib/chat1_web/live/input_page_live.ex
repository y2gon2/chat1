defmodule Chat1Web.InputPageLive do
  use Chat1Web, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, number: 5, form111: to_form(%{}))}
  end

  def test(assigns) do
    ~H"""
    This is a test
    """
  end

  # def handle_event("add", _params, socket) do
  #   {:noreply, assign(socket, number: socket.assigns.number + 1)}
  # end

  def handle_event("simple_add", _params, %{assigns: %{number: current_number}} = socket) do
    new_number = current_number + 1
    {:noreply, assign(socket, number: new_number)}
  end

  def handle_event("adding_more", %{"add_amount" => the_added_amount}, %{assigns: %{number: current_number}} = socket) do
    {amount, _remainder} = Integer.parse(the_added_amount)
    {:noreply, assign(socket, number: current_number + amount)}
  end

end
