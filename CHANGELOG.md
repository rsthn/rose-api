# v2.0.23 - Feb 04 2025

#### QoL
- Updated `deploy` lib to support `EVAL`.
- Updated `pull` and `release` scripts.
- Patched database update script to revert back (rollback) if the update fails.

<br/>

# v2.0.22 - Jan 05 2025

#### QoL
- Updated `pull` script and `deploy` lib to handle the script.
- Added fields `version` (from VERSION file) and `commit` (from COMMIT file) to the API banner.
- Added optional `value` field to the `system/generate-password` function.

<br/>

# v2.0.21 - Dec 02 2024

#### General
- Setup version tracking and script to maintain the changelog.
- Fixed bug in `utils:update-photo-image` function.
- Added `default now()` to several `created_at` fields.
