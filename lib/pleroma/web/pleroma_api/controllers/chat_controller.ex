# Pleroma: A lightweight social networking server
# Copyright © 2017-2020 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only
defmodule Pleroma.Web.PleromaAPI.ChatController do
  use Pleroma.Web, :controller

  alias Pleroma.Activity
  alias Pleroma.Chat
  alias Pleroma.ChatMessageReference
  alias Pleroma.Object
  alias Pleroma.Pagination
  alias Pleroma.Plugs.OAuthScopesPlug
  alias Pleroma.Repo
  alias Pleroma.User
  alias Pleroma.Web.CommonAPI
  alias Pleroma.Web.PleromaAPI.ChatView
  alias Pleroma.Web.PleromaAPI.ChatMessageReferenceView

  import Ecto.Query
  import Pleroma.Web.ActivityPub.ObjectValidator, only: [stringify_keys: 1]

  action_fallback(Pleroma.Web.MastodonAPI.FallbackController)

  plug(
    OAuthScopesPlug,
    %{scopes: ["write:statuses"]}
    when action in [:post_chat_message, :create, :mark_as_read, :delete_message]
  )

  plug(
    OAuthScopesPlug,
    %{scopes: ["read:statuses"]} when action in [:messages, :index, :show]
  )

  plug(OpenApiSpex.Plug.CastAndValidate, render_error: Pleroma.Web.ApiSpec.RenderError)

  defdelegate open_api_operation(action), to: Pleroma.Web.ApiSpec.ChatOperation

  def delete_message(%{assigns: %{user: %{id: user_id} = user}} = conn, %{
        message_id: message_id,
        id: chat_id
      }) do
    with %ChatMessageReference{} = cm_ref <-
           ChatMessageReference.get_by_id(message_id),
         ^chat_id <- cm_ref.chat_id |> to_string(),
         %Chat{user_id: ^user_id} <- Chat.get_by_id(chat_id),
         {:ok, _} <- remove_or_delete(cm_ref, user) do
      conn
      |> put_view(ChatMessageReferenceView)
      |> render("show.json", chat_message_reference: cm_ref)
    else
      _e ->
        {:error, :could_not_delete}
    end
  end

  defp remove_or_delete(
         %{object: %{data: %{"actor" => actor, "id" => id}}},
         %{ap_id: actor} = user
       ) do
    with %Activity{} = activity <- Activity.get_create_by_object_ap_id(id) do
      CommonAPI.delete(activity.id, user)
    end
  end

  defp remove_or_delete(cm_ref, _) do
    cm_ref
    |> ChatMessageReference.delete()
  end

  def post_chat_message(
        %{body_params: params, assigns: %{user: %{id: user_id} = user}} = conn,
        %{
          id: id
        }
      ) do
    with %Chat{} = chat <- Repo.get_by(Chat, id: id, user_id: user_id),
         %User{} = recipient <- User.get_cached_by_ap_id(chat.recipient),
         {:ok, activity} <-
           CommonAPI.post_chat_message(user, recipient, params[:content],
             media_id: params[:media_id]
           ),
         message <- Object.normalize(activity, false),
         cm_ref <- ChatMessageReference.for_chat_and_object(chat, message) do
      conn
      |> put_view(ChatMessageReferenceView)
      |> render("show.json", for: user, chat_message_reference: cm_ref)
    end
  end

  def mark_as_read(%{assigns: %{user: %{id: user_id}}} = conn, %{id: id}) do
    with %Chat{} = chat <- Repo.get_by(Chat, id: id, user_id: user_id),
         {:ok, chat} <- Chat.mark_as_read(chat) do
      conn
      |> put_view(ChatView)
      |> render("show.json", chat: chat)
    end
  end

  def messages(%{assigns: %{user: %{id: user_id} = user}} = conn, %{id: id} = params) do
    with %Chat{} = chat <- Repo.get_by(Chat, id: id, user_id: user_id) do
      cm_refs =
        chat
        |> ChatMessageReference.for_chat_query()
        |> Pagination.fetch_paginated(params |> stringify_keys())

      conn
      |> put_view(ChatMessageReferenceView)
      |> render("index.json", for: user, chat_message_references: cm_refs)
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "not found"})
    end
  end

  def index(%{assigns: %{user: %{id: user_id} = user}} = conn, params) do
    blocked_ap_ids = User.blocked_users_ap_ids(user)

    chats =
      from(c in Chat,
        where: c.user_id == ^user_id,
        where: c.recipient not in ^blocked_ap_ids,
        order_by: [desc: c.updated_at]
      )
      |> Pagination.fetch_paginated(params |> stringify_keys)

    conn
    |> put_view(ChatView)
    |> render("index.json", chats: chats)
  end

  def create(%{assigns: %{user: user}} = conn, params) do
    with %User{ap_id: recipient} <- User.get_by_id(params[:id]),
         {:ok, %Chat{} = chat} <- Chat.get_or_create(user.id, recipient) do
      conn
      |> put_view(ChatView)
      |> render("show.json", chat: chat)
    end
  end

  def show(%{assigns: %{user: user}} = conn, params) do
    with %Chat{} = chat <- Repo.get_by(Chat, user_id: user.id, id: params[:id]) do
      conn
      |> put_view(ChatView)
      |> render("show.json", chat: chat)
    end
  end
end
