# Pleroma: A lightweight social networking server
# Copyright © 2017-2021 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.Plugs.MappedSignatureToIdentityPlugTest do
  use Pleroma.Web.ConnCase
  alias Pleroma.Web.Plugs.MappedSignatureToIdentityPlug

  import Tesla.Mock
  import Plug.Conn

  import Pleroma.Tests.Helpers, only: [clear_config: 2]

  setup do
    mock(fn env -> apply(HttpRequestMock, :request, [env]) end)
    :ok
  end

  defp set_signature(conn, key_id) do
    conn
    |> put_req_header("signature", "keyId=\"#{key_id}\"")
    |> assign(:valid_signature, true)
  end

  test "it successfully maps a valid identity with a valid signature" do
    conn =
      build_conn(:get, "/doesntmattter")
      |> set_signature("http://mastodon.example.org/users/admin")
      |> MappedSignatureToIdentityPlug.call(%{})

    refute is_nil(conn.assigns.user)
  end

  test "it successfully maps a valid identity with a valid signature with payload" do
    conn =
      build_conn(:post, "/doesntmattter", %{"actor" => "http://mastodon.example.org/users/admin"})
      |> set_signature("http://mastodon.example.org/users/admin")
      |> MappedSignatureToIdentityPlug.call(%{})

    refute is_nil(conn.assigns.user)
  end

  test "it considers a mapped identity to be invalid when it mismatches a payload" do
    conn =
      build_conn(:post, "/doesntmattter", %{"actor" => "http://mastodon.example.org/users/admin"})
      |> set_signature("https://niu.moe/users/rye")
      |> MappedSignatureToIdentityPlug.call(%{})

    assert %{valid_signature: false} == conn.assigns
  end

  test "it considers a mapped identity to be invalid when the associated instance is blocked" do
    clear_config([:activitypub, :authorized_fetch_mode], true)

    clear_config([:mrf_simple, :reject], [
      {"mastodon.example.org", "anime is banned"}
    ])

    on_exit(fn ->
      Pleroma.Config.put([:activitypub, :authorized_fetch_mode], false)
      Pleroma.Config.put([:mrf_simple, :reject], [])
    end)

    conn =
      build_conn(:post, "/doesntmattter", %{"actor" => "http://mastodon.example.org/users/admin"})
      |> set_signature("http://mastodon.example.org/users/admin")
      |> MappedSignatureToIdentityPlug.call(%{})

    assert %{valid_signature: false} == conn.assigns
  end

  test "allowlist federation: it considers a mapped identity to be valid when the associated instance is allowed" do
    clear_config([:activitypub, :authorized_fetch_mode], true)

    clear_config([:mrf_simple, :accept], [
      {"mastodon.example.org", "anime is allowed"}
    ])

    on_exit(fn ->
      Pleroma.Config.put([:activitypub, :authorized_fetch_mode], false)
      Pleroma.Config.put([:mrf_simple, :accept], [])
    end)

    conn =
      build_conn(:post, "/doesntmattter", %{"actor" => "http://mastodon.example.org/users/admin"})
      |> set_signature("http://mastodon.example.org/users/admin")
      |> MappedSignatureToIdentityPlug.call(%{})

    assert conn.assigns[:valid_signature]
    refute is_nil(conn.assigns.user)
  end

  test "allowlist federation: it considers a mapped identity to be invalid when the associated instance is not allowed" do
    clear_config([:activitypub, :authorized_fetch_mode], true)

    clear_config([:mrf_simple, :accept], [
      {"misskey.example.org", "anime is allowed"}
    ])

    on_exit(fn ->
      Pleroma.Config.put([:activitypub, :authorized_fetch_mode], false)
      Pleroma.Config.put([:mrf_simple, :accept], [])
    end)

    conn =
      build_conn(:post, "/doesntmattter", %{"actor" => "http://mastodon.example.org/users/admin"})
      |> set_signature("http://mastodon.example.org/users/admin")
      |> MappedSignatureToIdentityPlug.call(%{})

    assert %{valid_signature: false} == conn.assigns
  end

  @tag skip: "known breakage; the testsuite presently depends on it"
  test "it considers a mapped identity to be invalid when the identity cannot be found" do
    conn =
      build_conn(:post, "/doesntmattter", %{"actor" => "http://mastodon.example.org/users/admin"})
      |> set_signature("http://niu.moe/users/rye")
      |> MappedSignatureToIdentityPlug.call(%{})

    assert %{valid_signature: false} == conn.assigns
  end
end
