# Pleroma: A lightweight social networking server
# Copyright © 2017-2019 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.PleromaAPI.PleromaAPIControllerTest do
  use Pleroma.Web.ConnCase

  alias Pleroma.Conversation.Participation
  alias Pleroma.Web.CommonAPI

  import Pleroma.Factory

  test "/api/v1/pleroma/conversations/:id/statuses", %{conn: conn} do
    user = insert(:user)
    other_user = insert(:user)
    third_user = insert(:user)

    {:ok, _activity} =
      CommonAPI.post(user, %{"status" => "Hi @#{third_user.nickname}!", "visibility" => "direct"})

    {:ok, activity} =
      CommonAPI.post(user, %{"status" => "Hi @#{other_user.nickname}!", "visibility" => "direct"})

    [participation] = Participation.for_user(other_user)

    {:ok, activity_two} =
      CommonAPI.post(other_user, %{
        "status" => "Hi!",
        "in_reply_to_status_id" => activity.id,
        "in_reply_to_conversation_id" => participation.id
      })

    result =
      conn
      |> assign(:user, other_user)
      |> get("/api/v1/pleroma/conversations/#{participation.id}/statuses")
      |> json_response(200)

    assert length(result) == 2

    id_one = activity.id
    id_two = activity_two.id
    assert [%{"id" => ^id_one}, %{"id" => ^id_two}] = result
  end
end
