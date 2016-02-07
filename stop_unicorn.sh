#! /bin/bash

kill -SIGQUIT $(cat shared/pids/unicorn.pid)
