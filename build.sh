#!/bin/sh

git archive --format=zip --worktree-attributes -o zzz_svr_wrs.pk3 $(git stash create)
