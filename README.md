# ansible-role-sensu-client

Configures `sensu-client`

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `sensu_client_user` | user name of `sensu-client` | `{{ __sensu_client_user }}` |
| `sensu_client_group` | group name of `sensu-client`  | `{{ __sensu_client_group }}` |
| `sensu_client_service` | service name of `sensu-client` | `{{ __sensu_client_service }}` |
| `sensu_client_config_dir` | path to configuration directory | `{{ __sensu_client_config_dir }}` |
| `sensu_client_config_file` | path to `config.json` | `{{ sensu_client_config_dir }}/config.json` |
| `sensu_client_conf_d_dir` | path to `conf.d` directory | `{{ sensu_client_config_dir }}/conf.d` |
| `sensu_client_extensions_dir` | path to `extensions` directory | `{{ sensu_client_config_dir }}/extensions` |
| `sensu_client_plugins_dir` | path to `plugins` directory | `{{ sensu_client_config_dir }}/plugins` |
| `sensu_client_flags` | not used yet | `""` |
| `sensu_client_config` | YAML representation of `config.json` | `{}` |
| `sensu_client_config_fragments` | YAML representation of JSON files under `conf.d` | `{}` |


## FreeBSD

| Variable | Default |
|----------|---------|
| `__sensu_client_user` | `sensu` |
| `__sensu_client_group` | `sensu` |
| `__sensu_client_service` | `sensu-client` |
| `__sensu_client_config_dir` | `/usr/local/etc/sensu` |

# Dependencies

* reallyenglish.freebsd-repos (FreeBSD only)

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-sensu-client
  vars:
    freebsd_repos:
      sensu:
        enabled: "true"
        url: https://sensu.global.ssl.fastly.net/freebsd/FreeBSD:10:amd64/
        mirror_type: srv
        signature_type: none
        priority: 100
        state: present
    sensu_client_config: {}
    sensu_client_config_fragments:
      client:
        client:
          name: "{{ ansible_fqdn }}"
          address: 127.0.0.1
          subscriptions:
            - production
            - something
      transport:
        transport:
          name: rabbitmq
          reconnect_on_error: True
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
