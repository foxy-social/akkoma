# Pleroma: A lightweight social networking server
# Copyright © 2017-2021 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ActivityPub.MRF.NoPlaceholderTextPolicy do
  @moduledoc "Ensure no content placeholder is present (such as the dot from mastodon)"
  @behaviour Pleroma.Web.ActivityPub.MRF.Policy

  @impl true
  def history_awareness, do: :auto

  @impl true
  def filter(
        %{
          "type" => type,
          "object" => %{"content" => content, "attachment" => _} = _child_object
        } = object
      )
      when type in ["Create", "Update"] and content in [".", "<p>.</p>"] do
    {:ok, put_in(object, ["object", "content"], "")}
  end

  @impl true
  def filter(object), do: {:ok, object}

  @impl true
  def describe, do: {:ok, %{}}
end
