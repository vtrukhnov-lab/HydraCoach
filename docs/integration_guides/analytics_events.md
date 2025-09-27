# HydraCoach Analytics Event Catalog

This document describes the unified analytics events that are now emitted to both Firebase Analytics and DevToDev. Each event includes the parameters forwarded to both providers and the screens or flows that fire them.

## Onboarding Funnel

The onboarding flow emits granular step-level analytics so that the entire conversion funnel can be reconstructed in either analytics backend.

### Step identifiers

| Step index | `step_id` value            | Screen/meaning                                     |
|-----------:|----------------------------|----------------------------------------------------|
| 0          | `welcome`                  | Intro hero screen                                  |
| 1          | `units`                    | Units selection                                    |
| 2          | `weight`                   | Weight slider                                      |
| 3          | `diet`                     | Diet & fasting preferences                         |
| 4          | `profile_summary`          | Summary + continue card                            |
| 5          | `notifications_preview`    | Notification examples carousel                     |
| 6          | `notification_permission`  | System notification permission decision            |
| 7          | `location_preview`         | Location benefit carousel                          |
| 8          | `location_permission`      | System location permission decision                |

### Fired events

* **`onboarding_start`** – fired once when the onboarding screen is first shown.
* **`onboarding_step_viewed`** – fired every time a step becomes active. Parameters: `step_id`, `step_index`, `screen_name` (also triggers a synthetic `screen_view`).
* **`onboarding_step_completed`** – fired when the user successfully finishes a step, including permission decisions. Parameters: `step_id`, `step_index`.
* **`onboarding_option_selected`** – granular metadata captured on key steps.
  * Units (`option: units_system`, values `metric` / `imperial`).
  * Weight (`option: weight_kg`, weight in kilograms).
  * Diet (`option: diet_mode`, fasting toggles and schedule selection).
  * Permission results (`option: status`, values `granted`, `denied`, `permanently_denied`, `limited`, `restricted`, or `skipped`).
* **`permission_prompt` / `permission_result`** – emitted whenever the notification or location request sheet is presented and resolved. Parameters: `permission` (`notifications` / `location`), `context: onboarding`, plus `status` on result.
* **`onboarding_profile_saved`** – fired when the profile summary is accepted. Parameters include `weight_kg`, `units`, `diet_mode`, and `fasting_enabled`.
* **`onboarding_skip`** – emitted when the user explicitly skips a step (notifications or location).
* **`onboarding_complete`** – emitted right before leaving onboarding for the main experience.

## Navigation & Engagement

* **`navigation_tab_selected`** – fired from the main shell bottom navigation. `tab` values: `home`, `history`, `notifications`, `reports`, `settings`.
* **Screen views** – the main shell now emits `screen_view` events with names `main_<tab>` whenever the active tab changes and immediately after initial mount.
* **`quick_add_menu_opened`** – emitted when the floating add button menu opens.

## Intake & Hydration Tracking

Hydration actions now generate consistent analytics with a `source` dimension.

* **`water_logged`** – fired whenever water-equivalent volume is added. `amount_ml` is the absolute amount, `source` can be:
  * `manual_entry` (default for catalog/supplement flows if not overridden)
  * `quick_add_single`, `quick_add_double`
  * `liquids_catalog`, `hot_drinks`, `favorite_beverage_<type>`, `history_undo`
* **`electrolyte_logged`** – emitted per-mineral when electrolytes are added. The event fires separately for `type` values `sodium`, `potassium`, and `magnesium` with `amount_mg` totals.
* **`coffee_logged`** – fired for caffeinated drinks that map to the coffee tracker (records `cups: 1`).

## Monetisation & Paywall

Every paywall entry point now identifies its origin via the `source` parameter. Values include `onboarding`, `settings`, `history`, `home_header`, `home_weather_card`, `home_electrolytes_card`, `home_sugar_card`, `status_card`, `pro_badge`, `pro_list_tile`, `pro_card`, `pro_row`, `favorite_beverages_bar`, `favorite_slot_selector`, `electrolytes`, `liquids_catalog`, `hot_drinks`, `supplements`, `sports`, `alcohol_log`, `feature_gate_<feature>`, `feature_teaser_<feature>`, `feature_card_<feature>`, and `app_route` (from global navigation).

* **`paywall_shown`** – fired in `initState` with `source` and optional `variant` (forwarded from constructor).
* **`paywall_plan_selected`** – triggered whenever the user switches plan tiles. Parameters: `plan` (`lifetime`, `annual`, `monthly`), `source`, `variant`.
* **`paywall_trial_toggled`** – fired when the free-trial switch is toggled (`enabled: true/false`).
* **`paywall_dismissed`** – emitted exactly once per presentation with reasons: `close_button`, `system_back`, `purchase_success`, `restore_success`, or `dispose` (fallback when the sheet is closed programmatically).

### Purchase flow

* **`subscription_purchase_attempt`** – fired before the (mock) purchase starts. Parameters: `product` (`monthly`, `annual`, `lifetime` via plan name), `source`, `trial_enabled`.
* **`subscription_purchase_result`** – emitted after the attempt finishes with `success`, `trial_enabled`, and optional `error` (truncated to 80 chars).
* **`subscription_started`** – logged in `SubscriptionService` after the local entitlement is activated (`product` equals the SKU identifier, `is_trial` currently `false` until trial support lands).

### Restore flow

* **`subscription_restore_attempt`** / **`subscription_restore_result`** – wrap the restore button with `success` flag and `source`.

## Permissions outside onboarding

Currently only onboarding uses the permissions events. The infrastructure supports other contexts by changing the `context` parameter when more flows are instrumented.

## Reporting reference

All new events (with key parameters) to add to dashboards:

| Event name                       | Key parameters                                                                      | Fired from                                                     |
|----------------------------------|--------------------------------------------------------------------------------------|----------------------------------------------------------------|
| `onboarding_start`               | –                                                                                    | Onboarding initialization                                      |
| `onboarding_step_viewed`         | `step_id`, `step_index`, `screen_name`                                              | Each onboarding page change                                   |
| `onboarding_step_completed`      | `step_id`, `step_index`                                                             | Onboarding step completion (including permissions)            |
| `onboarding_option_selected`     | See section above for per-step option keys                                          | Onboarding selections                                          |
| `onboarding_profile_saved`       | `weight_kg`, `units`, `diet_mode`, `fasting_enabled`                                | Summary confirmation                                           |
| `permission_prompt`              | `permission`, `context`                                                             | Before system prompt                                           |
| `permission_result`              | `permission`, `context`, `status`                                                   | After permission flow                                          |
| `onboarding_complete`            | –                                                                                    | Before leaving onboarding                                      |
| `paywall_shown`                  | `source`, `variant`                                                                 | Paywall `initState`                                            |
| `paywall_plan_selected`          | `plan`, `source`, `variant`                                                         | Plan tile tap                                                  |
| `paywall_trial_toggled`          | `source`, `enabled`                                                                 | Trial switch toggle                                            |
| `paywall_dismissed`              | `source`, `reason`                                                                  | Paywall exit (any path)                                        |
| `subscription_purchase_attempt`  | `product`, `source`, `trial_enabled`                                                | CTA tap before purchase                                        |
| `subscription_purchase_result`   | `product`, `source`, `success`, `trial_enabled`, optional `error`                   | Purchase outcome                                               |
| `subscription_started`           | `product`, `is_trial`                                                               | Post-activation in service                                     |
| `subscription_restore_attempt`   | `source`                                                                            | Restore button tap                                             |
| `subscription_restore_result`    | `source`, `success`                                                                 | Restore outcome                                                |
| `navigation_tab_selected`        | `tab`                                                                               | Bottom navigation taps (including disabled “reports”)         |
| `water_logged`                   | `amount_ml`, `source`, `hour`                                                       | All water-equivalent intakes (quick add, catalog, undo, etc.)  |
| `electrolyte_logged`             | `type`, `amount_mg`                                                                 | Electrolyte intakes                                            |
| `coffee_logged`                  | `cups`, `hour`                                                                      | Hot drink analytics when caffeine is present                   |
| `quick_add_menu_opened`          | –                                                                                    | Floating action button menu                                    |

This catalog should be kept up to date as new analytics touch points are added so product, marketing, and data teams can rely on a single reference.
