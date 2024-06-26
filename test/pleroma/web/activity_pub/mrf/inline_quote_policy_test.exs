# Pleroma: A lightweight social networking server
# Copyright © 2017-2021 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ActivityPub.MRF.InlineQuotePolicyTest do
  alias Pleroma.Web.ActivityPub.MRF.InlineQuotePolicy
  alias Pleroma.Object
  use Pleroma.DataCase

  setup_all do
    Tesla.Mock.mock_global(fn env -> apply(HttpRequestMock, :request, [env]) end)
    :ok
  end

  test "adds quote URL to post content" do
    quote_url = "https://mastodon.social/users/emelie/statuses/101849165031453009"

    activity = %{
      "type" => "Create",
      "actor" => "https://example.com/users/alex",
      "object" => %{
        "type" => "Note",
        "content" => "<p>Nice post</p>",
        "quoteUri" => quote_url
      }
    }

    # Prefetch the quoted post
    %Object{} = Object.normalize(quote_url, fetch: true)

    {:ok, %{"object" => %{"content" => filtered}}} = InlineQuotePolicy.filter(activity)

    assert filtered ==
             "<p>Nice post<span class=\"quote-inline\"><br/><br/>RE: <a href=\"https://mastodon.social/@emelie/101849165031453009\">https://mastodon.social/@emelie/101849165031453009</a></span></p>"
  end

  test "ignores Misskey quote posts" do
    object = File.read!("test/fixtures/quote_post/misskey_quote_post.json") |> Jason.decode!()

    activity = %{
      "type" => "Create",
      "actor" => "https://misskey.io/users/7rkrarq81i",
      "object" => object
    }

    {:ok, filtered} = InlineQuotePolicy.filter(activity)
    assert filtered == activity
  end

  test "ignores Fedibird quote posts" do
    object = File.read!("test/fixtures/quote_post/fedibird_quote_post.json") |> Jason.decode!()

    # Normally the ObjectValidator will fix this before it reaches MRF
    object = Map.put(object, "quoteUrl", object["quoteURL"])

    activity = %{
      "type" => "Create",
      "actor" => "https://fedibird.com/users/noellabo",
      "object" => object
    }

    {:ok, filtered} = InlineQuotePolicy.filter(activity)
    assert filtered == activity
  end
end
