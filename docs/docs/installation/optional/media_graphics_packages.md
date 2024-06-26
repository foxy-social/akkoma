# Optional software packages needed for specific functionality

For specific Akkoma functionality (which is disabled by default) some or all of the below packages are required:
  * `ImageMagick`
  * `ffmpeg`
  * `exiftool`
  
Please refer to documentation in `docs/installation` on how to install them on specific OS.
  
Note: the packages are not required with the current default settings of Akkoma.

## `ImageMagick`

`ImageMagick` is a set of tools to create, edit, compose, or convert bitmap images.

It is required for the following Akkoma features:
  * `Pleroma.Upload.Filters.Mogrify`, `Pleroma.Upload.Filters.Mogrifun` upload filters (related config: `Pleroma.Upload/filters` in `config/config.exs`)
  * Media preview proxy for still images (related config: `media_preview_proxy/enabled` in `config/config.exs`)
  
## `ffmpeg`

`ffmpeg` is software to record, convert and stream audio and video.

It is required for the following Akkoma features:
  * Media preview proxy for videos (related config: `media_preview_proxy/enabled` in `config/config.exs`)

## `exiftool`

`exiftool` is media files metadata reader/writer.

It is required for the following Akkoma features:
  * `Pleroma.Upload.Filters.Exiftool.StripMetadata` upload filter (related config: `Pleroma.Upload/filters` in `config/config.exs`)
  * `Pleroma.Upload.Filters.Exiftool.ReadDescription` upload filter (related config: `Pleroma.Upload/filters` in `config/config.exs`)
