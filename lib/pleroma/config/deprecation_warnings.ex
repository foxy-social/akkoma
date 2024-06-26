# Pleroma: A lightweight social networking server
# Copyright © 2017-2021 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Config.DeprecationWarnings do
  alias Pleroma.Config

  require Logger
  alias Pleroma.Config

  @type config_namespace() :: atom() | [atom()]
  @type config_map() :: {config_namespace(), config_namespace(), String.t()}

  @mrf_config_map [
    {[:instance, :rewrite_policy], [:mrf, :policies],
     "\n* `config :pleroma, :instance, rewrite_policy` is now `config :pleroma, :mrf, policies`"},
    {[:instance, :mrf_transparency], [:mrf, :transparency],
     "\n* `config :pleroma, :instance, mrf_transparency` is now `config :pleroma, :mrf, transparency`"},
    {[:instance, :mrf_transparency_exclusions], [:mrf, :transparency_exclusions],
     "\n* `config :pleroma, :instance, mrf_transparency_exclusions` is now `config :pleroma, :mrf, transparency_exclusions`"},
    {[:instance, :quarantined_instances], [:mrf_simple, :reject],
     "\n* `config :pleroma, :instance, :quarantined_instances` is now covered by `:pleroma, :mrf_simple, :reject`"}
  ]

  def check_exiftool_filter do
    filters = Config.get([Pleroma.Upload]) |> Keyword.get(:filters, [])

    if Pleroma.Upload.Filter.Exiftool in filters do
      Logger.warning("""
      !!!DEPRECATION WARNING!!!
      Your config is using Exiftool as a filter instead of Exiftool.StripMetadata. This should work for now, but you are advised to change to the new configuration to prevent possible issues later:

      ```
      config :pleroma, Pleroma.Upload,
        filters: [Pleroma.Upload.Filter.Exiftool]
      ```

      Is now


      ```
      config :pleroma, Pleroma.Upload,
        filters: [Pleroma.Upload.Filter.Exiftool.StripMetadata]
      ```
      """)

      new_config =
        filters
        |> Enum.map(fn
          Pleroma.Upload.Filter.Exiftool -> Pleroma.Upload.Filter.Exiftool.StripMetadata
          filter -> filter
        end)

      Config.put([Pleroma.Upload, :filters], new_config)

      :error
    else
      :ok
    end
  end

  def check_simple_policy_tuples do
    has_strings =
      Config.get([:mrf_simple])
      |> Enum.any?(fn {_, v} -> is_list(v) and Enum.any?(v, &is_binary/1) end)

    if has_strings do
      Logger.warning("""
      !!!DEPRECATION WARNING!!!
      Your config is using strings in the SimplePolicy configuration instead of tuples. They should work for now, but you are advised to change to the new configuration to prevent possible issues later:

      ```
      config :pleroma, :mrf_simple,
        media_removal: ["instance.tld"],
        media_nsfw: ["instance.tld"],
        federated_timeline_removal: ["instance.tld"],
        report_removal: ["instance.tld"],
        reject: ["instance.tld"],
        followers_only: ["instance.tld"],
        accept: ["instance.tld"],
        avatar_removal: ["instance.tld"],
        banner_removal: ["instance.tld"],
        reject_deletes: ["instance.tld"]
      ```

      Is now


      ```
      config :pleroma, :mrf_simple,
        media_removal: [{"instance.tld", "Reason for media removal"}],
        media_nsfw: [{"instance.tld", "Reason for media nsfw"}],
        federated_timeline_removal: [{"instance.tld", "Reason for federated timeline removal"}],
        report_removal: [{"instance.tld", "Reason for report removal"}],
        reject: [{"instance.tld", "Reason for reject"}],
        followers_only: [{"instance.tld", "Reason for followers only"}],
        accept: [{"instance.tld", "Reason for accept"}],
        avatar_removal: [{"instance.tld", "Reason for avatar removal"}],
        banner_removal: [{"instance.tld", "Reason for banner removal"}],
        reject_deletes: [{"instance.tld", "Reason for reject deletes"}]
      ```
      """)

      new_config =
        Config.get([:mrf_simple])
        |> Enum.filter(fn {_k, v} -> not is_atom(v) end)
        |> Enum.map(fn {k, v} ->
          {k,
           Enum.map(v, fn
             {instance, reason} -> {instance, reason}
             instance -> {instance, ""}
           end)}
        end)

      Config.put([:mrf_simple], new_config)

      :error
    else
      :ok
    end
  end

  def check_quarantined_instances_tuples do
    has_strings = Config.get([:instance, :quarantined_instances], []) |> Enum.any?(&is_binary/1)

    if has_strings do
      Logger.warning("""
      !!!DEPRECATION WARNING!!!
      Your config is using strings in the quarantined_instances configuration instead of tuples. They should work for now, but you are advised to change to the new configuration to prevent possible issues later:

      ```
      config :pleroma, :instance,
        quarantined_instances: ["instance.tld"]
      ```

      Is now


      ```
      config :pleroma, :instance,
        quarantined_instances: [{"instance.tld", "Reason for quarantine"}]
      ```
      """)

      new_config =
        Config.get([:instance, :quarantined_instances])
        |> Enum.map(fn
          {instance, reason} -> {instance, reason}
          instance -> {instance, ""}
        end)

      Config.put([:instance, :quarantined_instances], new_config)

      :error
    else
      :ok
    end
  end

  def check_transparency_exclusions_tuples do
    has_strings = Config.get([:mrf, :transparency_exclusions]) |> Enum.any?(&is_binary/1)

    if has_strings do
      Logger.warning("""
      !!!DEPRECATION WARNING!!!
      Your config is using strings in the transparency_exclusions configuration instead of tuples. They should work for now, but you are advised to change to the new configuration to prevent possible issues later:

      ```
      config :pleroma, :mrf,
        transparency_exclusions: ["instance.tld"]
      ```

      Is now


      ```
      config :pleroma, :mrf,
        transparency_exclusions: [{"instance.tld", "Reason to exlude transparency"}]
      ```
      """)

      new_config =
        Config.get([:mrf, :transparency_exclusions])
        |> Enum.map(fn
          {instance, reason} -> {instance, reason}
          instance -> {instance, ""}
        end)

      Config.put([:mrf, :transparency_exclusions], new_config)

      :error
    else
      :ok
    end
  end

  def check_hellthread_threshold do
    if Config.get([:mrf_hellthread, :threshold]) do
      Logger.warning("""
      !!!DEPRECATION WARNING!!!
      You are using the old configuration mechanism for the hellthread filter. Please check config.md.
      """)

      :error
    else
      :ok
    end
  end

  def warn do
    [
      check_hellthread_threshold(),
      check_old_mrf_config(),
      check_media_proxy_whitelist_config(),
      check_welcome_message_config(),
      check_activity_expiration_config(),
      check_remote_ip_plug_name(),
      check_uploders_s3_public_endpoint(),
      check_quarantined_instances_tuples(),
      check_transparency_exclusions_tuples(),
      check_simple_policy_tuples(),
      check_http_adapter(),
      check_uploader_base_url_set(),
      check_uploader_base_url_is_not_base_domain(),
      check_exiftool_filter()
    ]
    |> Enum.reduce(:ok, fn
      :ok, :ok -> :ok
      _, _ -> :error
    end)
  end

  def check_welcome_message_config do
    instance_config = Pleroma.Config.get([:instance])

    use_old_config =
      Keyword.has_key?(instance_config, :welcome_user_nickname) or
        Keyword.has_key?(instance_config, :welcome_message)

    if use_old_config do
      Logger.error("""
      !!!DEPRECATION WARNING!!!
      Your config is using the old namespace for Welcome messages configuration. You need to convert to the new namespace. e.g.,
      \n* `config :pleroma, :instance, welcome_user_nickname` and `config :pleroma, :instance, welcome_message` are now equal to:
      \n* `config :pleroma, :welcome, direct_message: [enabled: true, sender_nickname: "NICKNAME", message: "Your welcome message"]`"
      """)

      :error
    else
      :ok
    end
  end

  def check_http_adapter do
    http_adapter = Application.get_env(:tesla, :adapter)

    case http_adapter do
      {Tesla.Adapter.Finch, _} ->
        :ok

      Tesla.Mock ->
        # tests do be testing
        :ok

      _anything_else ->
        Logger.error("""
        !!!CONFIG ERROR!!!
        Your config is using a custom tesla adapter, this was standardised
        to finch in 2022.06, and alternate adapters were removed in 2023.02.
        Please ensure you either:
        \n* do not have any custom value for `:tesla, :adapter`, or
        \n* have `config :tesla, :adapter, {Tesla.Adapter.Finch, name: MyFinch}`
        (your current value is #{inspect(http_adapter)})
        """)

        :error
    end
  end

  def check_old_mrf_config do
    warning_preface = """
    !!!DEPRECATION WARNING!!!
    Your config is using old namespaces for MRF configuration. They should work for now, but you are advised to change to new namespaces to prevent possible issues later:
    """

    move_namespace_and_warn(@mrf_config_map, warning_preface)
  end

  @spec move_namespace_and_warn([config_map()], String.t()) :: :ok | nil
  def move_namespace_and_warn(config_map, warning_preface) do
    warning =
      Enum.reduce(config_map, "", fn
        {old, new, err_msg}, acc ->
          old_config = Config.get(old)

          if old_config do
            Config.put(new, old_config)
            acc <> err_msg
          else
            acc
          end
      end)

    if warning == "" do
      :ok
    else
      Logger.warning(warning_preface <> warning)
      :error
    end
  end

  @spec check_media_proxy_whitelist_config() :: :ok | nil
  def check_media_proxy_whitelist_config do
    whitelist = Config.get([:media_proxy, :whitelist])

    if Enum.any?(whitelist, &(not String.starts_with?(&1, "http"))) do
      Logger.warning("""
      !!!DEPRECATION WARNING!!!
      Your config is using old format (only domain) for MediaProxy whitelist option. Setting should work for now, but you are advised to change format to scheme with port to prevent possible issues later.
      """)

      :error
    else
      :ok
    end
  end

  @spec check_activity_expiration_config() :: :ok | nil
  def check_activity_expiration_config do
    warning_preface = """
    !!!DEPRECATION WARNING!!!
      Your config is using old namespace for activity expiration configuration. Setting should work for now, but you are advised to change to new namespace to prevent possible issues later:
    """

    move_namespace_and_warn(
      [
        {Pleroma.ActivityExpiration, Pleroma.Workers.PurgeExpiredActivity,
         "\n* `config :pleroma, Pleroma.ActivityExpiration` is now `config :pleroma, Pleroma.Workers.PurgeExpiredActivity`"}
      ],
      warning_preface
    )
  end

  @spec check_remote_ip_plug_name() :: :ok | nil
  def check_remote_ip_plug_name do
    warning_preface = """
    !!!DEPRECATION WARNING!!!
    Your config is using old namespace for RemoteIp Plug. Setting should work for now, but you are advised to change to new namespace to prevent possible issues later:
    """

    move_namespace_and_warn(
      [
        {Pleroma.Plugs.RemoteIp, Pleroma.Web.Plugs.RemoteIp,
         "\n* `config :pleroma, Pleroma.Plugs.RemoteIp` is now `config :pleroma, Pleroma.Web.Plugs.RemoteIp`"}
      ],
      warning_preface
    )
  end

  @spec check_uploders_s3_public_endpoint() :: :ok | nil
  def check_uploders_s3_public_endpoint do
    s3_config = Pleroma.Config.get([Pleroma.Uploaders.S3])

    use_old_config = Keyword.has_key?(s3_config, :public_endpoint)

    if use_old_config do
      Logger.error("""
      !!!DEPRECATION WARNING!!!
      Your config is using the old setting for controlling the URL of media uploaded to your S3 bucket.\n
      Please make the following change at your earliest convenience.\n
      \n* `config :pleroma, Pleroma.Uploaders.S3, public_endpoint` is now equal to:
      \n* `config :pleroma, Pleroma.Upload, base_url`
      """)

      :error
    else
      :ok
    end
  end

  def check_uploader_base_url_set() do
    uses_local_uploader? = Config.get([Pleroma.Upload, :uploader]) == Pleroma.Uploaders.Local
    base_url = Pleroma.Config.get([Pleroma.Upload, :base_url])

    if base_url || !uses_local_uploader? do
      :ok
    else
      Logger.error("""
      !!!WARNING!!!
      Your config does not specify a base_url for uploads!
      Please make the following change:\n
      \n* `config :pleroma, Pleroma.Upload, base_url: "https://example.com/media/`
      \n
      \nPlease note that it is HEAVILY recommended to use a subdomain to host user-uploaded media!
      """)

      # This is a hard exit - the uploader will not work without a base_url
      raise ArgumentError, message: "No base_url set for uploads - please set one in your config!"
    end
  end

  def check_uploader_base_url_is_not_base_domain() do
    uses_local_uploader? = Config.get([Pleroma.Upload, :uploader]) == Pleroma.Uploaders.Local

    uploader_host =
      [Pleroma.Upload, :base_url]
      |> Pleroma.Config.get()
      |> URI.parse()
      |> Map.get(:host)

    akkoma_host =
      [Pleroma.Web.Endpoint, :url]
      |> Pleroma.Config.get()
      |> Keyword.get(:host)

    if uploader_host == akkoma_host && uses_local_uploader? do
      Logger.error("""
      !!!WARNING!!!
      Your Akkoma Host and your Upload base_url's host are the same!
      This can potentially be insecure!

      It is HIGHLY recommended that you migrate your media uploads
      to a subdomain at your earliest convenience
      """)
    end

    # This isn't actually an error condition, just a warning
    :ok
  end
end
