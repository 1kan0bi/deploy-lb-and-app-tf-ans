deploy_nginx
=========

Requirements
------------

This playbook works on debian machines

Role Variables
--------------

| Variable                | Required | Default | Choices                   | Comments                                 |
|-------------------------|----------|---------|---------------------------|------------------------------------------|
| worker_connections      | yes      |   1024  | 1024-4096                 | nginx.conf variable                      |
| workers_processes       | yes      |    1    | auto, 1-...               | nginx.conf variable                      |
| ports                   | yes      |   80    | 80,81...                  | virtualhost variable                     |

Example Playbook
----------------

    - hosts: all
      roles:
         - deploy_nginx
