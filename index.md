---
layout: home
title:  Cloud Platform Services Comparison
description: Compare service mappings across clouds providers and their infrastructure platforms.
---
{% assign providers = site.data.providers.providers %}
<style>
{% for provider in providers %}
#provider-toggle-{{ provider.id }}:checked ~ .comparison-controls label[for="provider-toggle-{{ provider.id }}"] {
  background: #111;
  border-color: #111;
  color: #fff;
}

#provider-toggle-{{ provider.id }}:not(:checked) ~ .comparison-controls label[for="provider-toggle-{{ provider.id }}"] {
  background: #fff;
  border-color: #c7d3de;
  color: #5c6b78;
}

#provider-toggle-{{ provider.id }}:not(:checked) ~ .comparison-groups .provider-{{ provider.id }} {
  display: none;
}
{% endfor %}
</style>

<section class="comparison-hero">
  <h1>Cloud Platform Service Comparison</h1>
  <p>
    Use the provider toggles to focus the view and collapse categories you do not need.
  </p>
</section>

<form class="comparison-layout">
  {% for provider in providers %}
    <input class="provider-toggle" type="checkbox" id="provider-toggle-{{ provider.id }}" checked>
  {% endfor %}

  <section class="comparison-controls" aria-label="Visible service providers">
    <div class="comparison-controls__header">
      <h2>Visible Service Providers</h2>
      <button type="reset" class="comparison-reset">Reset</button>
    </div>
    <div class="provider-filter-list">
      {% for provider in providers %}
        <label class="provider-chip" for="provider-toggle-{{ provider.id }}">{{ provider.label }}</label>
      {% endfor %}
    </div>
  </section>

  <div class="comparison-groups">
    {% assign categories = site.data.cloudservices.services | group_by: "category" %}
    {% for category in categories %}
      <details class="category-group" open>
        <summary class="category-group__summary">
          <span class="category-group__title">{{ category.name }}</span>
        </summary>
        <div class="comparison-table-wrap">
          <table class="comparison-table">
            <thead>
              <tr>
                <th class="service-column">Service</th>
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
