#!/bin/bash -e

# END_POINT="https://development-runner-habit.herokuapp.com"
# SECRET="1234567890"

END_POINT="https://api.runner-habit.timistudio.dev"
SECRET="TimiP@ssw0rd123"

hasura migrate apply --database-name default --endpoint "${END_POINT}" --admin-secret "${SECRET}"

hasura metadata apply --endpoint "${END_POINT}" --admin-secret "${SECRET}"

hasura metadata reload --endpoint "${END_POINT}" --admin-secret "${SECRET}"
