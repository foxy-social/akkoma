defmodule Mix.Tasks.Pleroma.UploadsTest do
  alias Pleroma.Upload
  use Pleroma.DataCase

  import Mock

  setup_all do
    Mix.shell(Mix.Shell.Process)

    on_exit(fn ->
      Mix.shell(Mix.Shell.IO)
    end)

    :ok
  end

  describe "running migrate_local" do
    test "uploads migrated" do
      with_mock Upload,
        store: fn %Upload{name: _file, path: _path}, _opts -> {:ok, %{}} end do
        Mix.Tasks.Pleroma.Uploads.run(["migrate_local", "S3"])

        assert_received {:mix_shell, :info, [message]}
        assert message =~ "Migrating files from local"

        assert_received {:mix_shell, :info, [message]}

        assert %{"total_count" => total_count} =
                 Regex.named_captures(~r"^Found (?<total_count>\d+) uploads$", message)

        assert_received {:mix_shell, :info, [message]}

        assert %{"count" => ^total_count, "total_count" => ^total_count} =
                 Regex.named_captures(
                   ~r"^Uploaded (?<count>\d+)/(?<total_count>\d+) files$",
                   message
                 )
      end
    end

    test "nonexistent uploader" do
      assert_raise RuntimeError, ~r/The uploader .* is not an existing/, fn ->
        Mix.Tasks.Pleroma.Uploads.run(["migrate_local", "nonexistent"])
      end
    end
  end
end