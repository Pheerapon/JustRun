#!/bin/bash -e

END_POINT="https://development-runner-habit.herokuapp.com"
SECRET="1234567890"

hasura console --endpoint "${END_POINT}" --admin-secret "${SECRET}"
