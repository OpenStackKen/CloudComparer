# Add `OpenStack`, Category Grouping, CSS-First Filtering, and Graphic Normalization

## Summary
- Add `OpenStack` as the eighth compared platform, displayed exactly as `OpenStack`.
- Group the comparison into category-based sections so categories can be shown or hidden without JS.
- Keep provider show/hide CSS-first with checkbox controls and no persistence across reloads.
- Do not implement column reordering in this iteration.
- Normalize graphics in both provider headers and service cells through shared markup and CSS constraints rather than bulk image rewriting.
- Remove the GitHub link strip from the top of the page.

## Implementation Changes
- Add `_data/providers.yml` as the ordered source of truth for provider rendering.
- Refactor `index.md` to render provider controls, one collapsible category section per category, and one comparison table inside each category section.
- Keep `_data/cloudservices.yml` as the source of service mappings, but normalize every row to include `aws`, `azure`, `google`, `ibm`, `oracle`, `alibaba`, `huawei`, and `openstack` in that order.
- Repair the existing missing `huawei` placeholder and add `openstack` placeholders or verified mappings for every service row.
- Normalize logos and service icons with shared wrappers and CSS containment rather than editing most source image files.
- Update page and site copy so the project refers to cloud platforms rather than only the previous public-cloud shortlist.

## Data Rules
- `OpenStack` remains a full-column scaffold with verified mappings only for clearly documented services.
- Unverified `OpenStack` rows use the standard empty `name`, empty `ref`, and `none.png` convention.
- Verified first-pass `OpenStack` mappings are limited to rows with official Rackspace/Genestack documentation support.

## UI Rules
- Provider visibility is controlled by CSS-only checkboxes and does not persist after reload.
- Category visibility is controlled with native `<details>` sections, all expanded by default.
- Provider order stays fixed.
- The `Service` column always remains visible.

## Validation
- Verify every service row has the normalized provider sequence including `openstack`.
- Verify every category renders as its own `<details>` section with a contained comparison table.
- Verify provider toggles hide and show matching columns across every category table with CSS only.
- Verify header logos and service icons render at normalized sizes.
- Run a Jekyll build when a matching Ruby/Bundler environment is available.
