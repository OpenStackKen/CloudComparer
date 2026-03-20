---
layout: home
title:  Cloud Platform Services Comparison
description: Compare service mappings across clouds providers and their infrastructure platforms.
---
{% assign providers = site.data.providers.providers %}
{% comment %}
The provider toggles are intentionally implemented without JavaScript.
Each checkbox sits before the sticky stack and the comparison groups, which lets the
generated sibling selectors below hide/show both the shared logo header cells and the
matching provider cells in every category table.
{% endcomment %}
<style>
{% for provider in providers %}
#provider-toggle-{{ provider.id }}:checked ~ .comparison-sticky-stack .comparison-controls label[for="provider-toggle-{{ provider.id }}"] {
  background: #2a7ae2;
  border-color: #2a7ae2;
  color: #fff;
}

#provider-toggle-{{ provider.id }}:not(:checked) ~ .comparison-sticky-stack .comparison-controls label[for="provider-toggle-{{ provider.id }}"] {
  background: #fdfdfd;
  border-color: #e8e8e8;
  color: #424242;
}

#provider-toggle-{{ provider.id }}:not(:checked) ~ .comparison-sticky-stack .provider-{{ provider.id }},
#provider-toggle-{{ provider.id }}:not(:checked) ~ .comparison-groups .provider-{{ provider.id }} {
  display: none;
}
{% endfor %}
</style>

<form class="comparison-layout">
  {% for provider in providers %}
    <input class="provider-toggle" type="checkbox" id="provider-toggle-{{ provider.id }}" checked>
  {% endfor %}

  {% comment %}
  The top stack is split into two pieces:
  1. the provider-filter controls
  2. a shared provider-logo table
  That shared table exists so the provider logos render once and can stay sticky while
  the category tables below keep a simpler body-only structure.
  {% endcomment %}
  <div class="comparison-sticky-stack">
    <section class="comparison-controls" aria-label="Visible service providers">
      <section class="comparison-hero">
        <h1>Cloud Platform Service Comparison</h1>
        <p>
          Use the provider toggles to focus the view and collapse categories you do not need.
        </p>
      </section>
      <div class="provider-filter-list">
        {% for provider in providers %}
          <label class="provider-chip" for="provider-toggle-{{ provider.id }}">{{ provider.label }}</label>
        {% endfor %}
        <button type="reset" class="comparison-reset">Reset</button>
      </div>
    </section>
    <div class="comparison-header-shell" aria-hidden="true">
      <table class="comparison-header-table">
        {% comment %}
        The shared header table and every category table use matching colgroups.
        That is the mechanism that keeps the sticky provider logos aligned with the
        provider columns rendered further down the page.
        {% endcomment %}
        <colgroup>
          <col class="service-column">
          {% for provider in providers %}
            <col class="provider-column provider-{{ provider.id }}">
          {% endfor %}
        </colgroup>
        <tbody>
          <tr>
            <th class="service-column comparison-header-table__spacer"></th>
            {% for provider in providers %}
              <th class="provider-column provider-{{ provider.id }}">
                {% if provider.header_type == "image" %}
                  <span class="provider-logo-frame">
                    <img src="{{ site.baseurl }}/{{ provider.header_src }}" alt="{{ provider.header_alt }}">
                  </span>
                {% else %}
                  <span class="provider-text-mark">{{ provider.label }}</span>
                {% endif %}
              </th>
            {% endfor %}
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <div class="comparison-groups">
    {% assign categories = site.data.cloudservices.services | group_by: "category" %}
    {% for category in categories %}
      <details class="category-group" open>
        <summary class="category-group__summary">
          <span class="category-group__title">{{ category.name }}</span>
        </summary>
        <div class="comparison-table-wrap">
          <table class="comparison-table">
            {% comment %}
            The visible provider header row was intentionally removed from each category
            table. A screen-reader-only thead is kept so the table still exposes column
            semantics, while the single shared sticky header above provides the visible UI.
            {% endcomment %}
            <colgroup>
              <col class="service-column">
              {% for provider in providers %}
                <col class="provider-column provider-{{ provider.id }}">
              {% endfor %}
            </colgroup>
            <thead class="comparison-table__sr-head">
              <tr>
                <th scope="col" class="service-column">Service</th>
                {% for provider in providers %}
                  <th scope="col" class="provider-column provider-{{ provider.id }}">{{ provider.label }}</th>
                {% endfor %}
              </tr>
            </thead>
            <tbody>
              {% for item in category.items %}
                <tr class="comparison-row">
                <th scope="row" class="service-name-cell">{{ item.subcategory }}</th>
                {% for provider in providers %}
                  {% assign provider_records = nil %}
                  {% for entry in item.service %}
                    {% if entry[provider.id] %}
                      {% assign provider_records = entry[provider.id] %}
                    {% endif %}
                  {% endfor %}
                  <td class="provider-column provider-{{ provider.id }}">
                    <ul class="service-records">
                      {% for record in provider_records %}
                        {% assign record_name = record.name | default: "" | strip %}
                        {% assign record_ref = record.ref | default: "" | strip %}
                        <li class="service-record">
                          <span class="service-icon-frame">
                            <img src="{{ site.baseurl }}/assets/img/cloudproviders/{{ provider.asset_dir }}/{{ record.icon }}" alt="">
                          </span>
                          {% if record_name == "" %}
                            <span class="service-record__name service-record__name--empty">None</span>
                          {% elsif record_ref != "" %}
                            <a href="{{ record_ref }}" target="_blank" rel="noopener noreferrer" class="service-record__link">{{ record.name }}</a>
                          {% else %}
                            <span class="service-record__name">{{ record.name }}</span>
                          {% endif %}
                        </li>
                      {% endfor %}
                    </ul>
                  </td>
                {% endfor %}
                </tr>
              {% endfor %}
            </tbody>
          </table>
        </div>
      </details>
    {% endfor %}
  </div>
</form>

<script>
  (function () {
    const stack = document.querySelector('.comparison-sticky-stack');
    if (!stack) return;

    // The section headers sit underneath a sticky logo/control stack whose height changes
    // as the layout wraps. Measure that stack and publish the exact pixel offset into CSS
    // so sticky category headers stop directly beneath it instead of relying on guessed values.
    const updateOffset = () => {
      const stickyTop = parseFloat(getComputedStyle(document.documentElement).getPropertyValue('--comparison-sticky-top')) || 0;
      const stackHeight = Math.ceil(stack.getBoundingClientRect().height);
      document.documentElement.style.setProperty('--comparison-stack-offset', `${stickyTop + stackHeight}px`);
    };

    updateOffset();
    window.addEventListener('load', updateOffset, { once: true });
    window.addEventListener('resize', updateOffset);

    if ('ResizeObserver' in window) {
      new ResizeObserver(updateOffset).observe(stack);
    }
  }());
</script>
