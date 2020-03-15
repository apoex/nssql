## 1.1.0 (2020-03-15)

  - Adds support to configure credentials via `ENV['NETSUITE_USER']` and `ENV['NETSUITE_PASSWORD']`

## 1.0.0 (2019-08-07)

  - New way of defining columns: `ns_column :column`
  - Uses `include` to support inheritance from other classes

## 0.1.1 (2019-04-08)

  - Now possible to get `table_name`, `primary_keys`, and `column` from a `NSSQL::Table`
  - Fixes problem with `NSSQL.select_array` method

## 0.1.0 (2019-04-08)

  - Initial release
